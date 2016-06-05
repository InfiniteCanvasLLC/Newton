class QuestionAnswerPair
    attr_accessor :question
    attr_accessor :answer
    attr_accessor :action_id
end

class LinkToActionPair
    attr_accessor :link_to
    attr_accessor :action_id
end

class NewAccountController < ApplicationController

    def initialize
        super
    end

    def home
        user_id = session[:user_id]
        actions = UserAction.where("user_id = " + user_id.to_s)

        @user = User.find(user_id)
        @num_actions = actions.count

        self.manage_actions_dynamically

        actions_array = actions.to_a

        @questions = Array.new
        @link_tos  = Array.new
        @current_nav_selection = "nav_home"

        #if current user id invalid (party deleted for instance)
        @current_user_party = get_user_current_party(@user)
        @current_user_party_name = @current_user_party.name;

        actions_array.each do |cur_action|

            if (cur_action.action_type == UserAction.question_type)
                qaPair = QuestionAnswerPair.new

                qaPair.question = Question.find(cur_action.action_id)
                qaPair.answer = QuestionAnswer.new
                qaPair.action_id = cur_action.id

                @questions << qaPair
            elsif (cur_action.action_type == UserAction.linkto_type)
                laPair = LinkToActionPair.new
                laPair.link_to = LinkTo.find(cur_action.action_id)
                laPair.action_id = cur_action.id
                @link_tos << laPair
            end
        end

        #resolve dst user id for all party invites
        # this is in the case where an invite was sent to someone who is not already part of Audicy
        invites = @user.get_all_party_invites
        invites.to_a.each do |invite|
            invite.dst_user_id ==  @user.id #if this is a new user, invited by a firend, their id is ivalid (-1)
            invite.save #Don't forget to save!
        end
    end

    #based on user state (are we missing some information)
    # we might want to assign some actions for the user to do.
    # ie: Update their gender, location, and age (or age group).
    # But also some party related requests might be in their queue
    def manage_actions_dynamically
      inviteLinkto = LinkTo.get_party_invitation_link #this could be nil, remember, we need to create it manually (only once though).

      if @user.get_all_party_invites.empty? == false
        if @user.is_assigned_linkto( inviteLinkto ) == false
          #create a new action and assign it to the user
          action = UserAction.new
          action.user_id = @user.id
          action.action_type = UserAction.linkto_type
          action.action_id = inviteLinkto.id
          action.save
        end
      else #the invites are empty we might have to remove the linkto
        if @user.is_assigned_linkto( inviteLinkto ) == true
          #remove it
          @user.get_actions.where("action_id" => inviteLinkto.id).delete_all
        end
      end
    end

    def enter_answer
        questionAnswer = QuestionAnswer.new
        action = UserAction.find(params[:action_id])

        questionAnswer.question_id = action.action_id
        questionAnswer.user_id = session[:user_id]
        questionAnswer.answer_integer = params[:answer_integer]
        questionAnswer.answer_text = params[:answer_text]

        questionAnswer.save

        action.destroy

        render nothing: true
    end

    def edit_user
        user_id = session[:user_id]
        user = User.find(user_id)
        #@TODO: SANITIZE!!! :)
        user.name   = params[:name]
        user.email  = params[:email]
        user.secondary_email = params[:secondary_email]
        user.gender   = params[:gender]
        user.birthday = params[:birthday]
        user.zip_code = params[:zip_code]
        user.description = params[:description]
        user.save

        redirect_to action: 'profile'
    end

    def handle_link_to
        action = UserAction.find(params[:action_id] )
        #action.destroy
        redirect_to params[:url]
    end

    def switch_party
        user_id = session[:user_id]
        @user = User.find(user_id)
        @user.current_party_index = params[:party_index]
        @user.save
        redirect_to action: 'home'
    end

    def leave_party
        @user = User.find(params[:user])
        @party = Party.find(params[:party])
        @user.current_party_index = [0, @user.current_party_index - 1].max
        @user.parties.delete(@party)
        @user.save
    end

    def create_party
    #@TODO: Check for param validity (eg: is there a party with the same name?)
        user_id = session[:user_id]
        @user = User.find(user_id)

        party = Party.new
        party.name = params[:name]
        party.description = params[:description]
        party.owner_user_id = user_id
        party.save

        #since the user created it, they are part of it
        @user.parties << party

        redirect_to action: 'party'
    end

    def edit_party
        #get and modify the party
        party = Party.find(params[:party_id])
        party.name = params[:name]
        party.description = params[:description]
        party.save

        redirect_to action: 'party'
    end

    def join_party
        user_id = session[:user_id]
        @user = User.find(user_id)
        party = Party.find(params[:party_id])

        #make sure user not already in the party
        if party.users.exists?(@user.id) == false
            party.users << @user #store user
        end

        @user.remove_party_invites(params[:party_id])

        redirect_to action: 'party'
    end

    def submit_party_invite_request
        friend_first_name = params[:first_name]
        friend_last_name = params[:last_name]
        friend_full_name = friend_first_name + " " + friend_last_name;
        friend_email = params[:email]
        user_id = session[:user_id]
        @user = User.find(user_id)
        @current_party = get_user_current_party(@user)

        #find the friend
        friend =
        User.where( :name => friend_full_name, :email => friend_email ).first ||
        User.where( :name => friend_full_name.capitalize, :email => friend_email ).first
        # if friend == @user (self invite)... just return
        #if friend belongs to @current_party just return
        if friend != nil
            if @current_party.users.exists?(friend.id) || friend.id == @user.id
                return
            end
        end

        #if this friend hasn't already been invited...
        invite = PartyInvite.where(:party_id => @current_party.id, :dst_user_email => friend_email).first
        if invite == nil
          #create party invite
          invite = PartyInvite.new
          invite.party_id       = @current_party.id
          invite.src_user_id    = @user.id
          invite.dst_user_id    = friend != nil ? friend.id : -1
          invite.dst_user_name  = friend_full_name
          invite.dst_user_email = friend_email
          invite.save

          #send an email
          Outreach.party_invite( @current_party, @user, friend_full_name, friend_email, "http://www.audicy.us/").deliver_now
        end

        redirect_to action: 'party'
    end

    def calendar
        user_id = session[:user_id]
        @user = User.find(user_id)
        @current_party = get_user_current_party(@user)

        @current_nav_selection = "nav_calendar"
    end

    def stats
        @current_nav_selection = "nav_stats"
    end

    def party
        user_id = session[:user_id]
        @user = User.find(user_id)
        @current_user_party = get_user_current_party(@user)
        @all_parties = Party.all
        @party_invites = @user.get_all_party_invites

        @current_nav_selection = "nav_party"
    end

    def feedback
        @current_nav_selection = "nav_feedback"
    end

    def profile
        user_id = session[:user_id]
        @user = User.find(user_id)
        @current_nav_selection = ""
    end

    def settings
        @current_nav_selection = ""
    end

    private

    #this function returns the user's current party
    def get_user_current_party(user)
        #if this is the first time the user logs in (current_party_index nil)
        if user.current_party_index.nil?
            user.current_party_index = 0
        end

        # if the @user.current_party_index is invalid in any way, this will returns user.pary[0]
        if user.current_party_index >= user.parties.count
            user.current_party_index = 0
            user.save
        end

        # if user.parties is empty we create a default party 0
        if user.parties.count == 0
           default_party = Party.new
           default_party.name = Party.random_name
           default_party.owner_user_id = user.id
           default_party.save
           user.parties << default_party
        end

        return user.party_at_index( user.current_party_index.to_i )
    end

end

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

    before_action :update_user_last_seen
    
    def initialize
        super
    end

    def home
        user_id = session[:user_id]
        actions = UserAction.where("user_id = " + user_id.to_s)

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
        if @user.is_assigned_linkto( inviteLinkto ) == false && inviteLinkto != nil
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
        #@TODO: SANITIZE!!! :)
        @user.name   = params[:name]
        @user.email  = params[:email]
        @user.secondary_email = params[:secondary_email]
        @user.gender   = params[:gender]
        @user.birthday = params[:birthday]
        @user.zip_code = params[:zip_code]
        @user.description = params[:description]
        @user.save

        redirect_to action: 'profile'
    end

    def handle_link_to
        action = UserAction.find(params[:action_id] )
        #action.destroy
        redirect_to params[:url]
    end

    def switch_party
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

        party = Party.new
        party.name = params[:name]
        party.description = params[:description]
        party.owner_user_id = @user.id
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

    def request_to_join_party
      party = Party.find(params[:party_id])
      #if the user already requested to join, no need to create a new request
      if party.did_user_request_to_join(@user.id) == false
        #create request
        request = JoinPartyRequest.new
        request.party_id   = party.id
        request.user_id    = @user.id
        request.message    = params[:description]
        request.save

        #send an email
        owner_id = party.get_owner.id
        email_subject = "Party Join Request"
        email_body = @user.name + " would like to join " + party.name
        Outreach.mail_to_user_id(owner_id, email_subject, email_body).deliver_now
      end

      redirect_to action: 'party'
    end

    def handle_user_request_to_join_party
      friend = User.find(params[:user_id])
      @current_party = get_user_current_party(@user)
      if @current_party.users.exists?(friend.id)#sanity check
        return
      end

      @current_party.users << friend
      @current_party.remove_party_join_requests(params[:user_id])

      redirect_to action: 'party'
    end

    def join_party
        party = Party.find(params[:party_id])

        #make sure user not already in the party
        if party.users.exists?(@user.id) == false
            party.users << @user #store user
        end

        @user.remove_party_invites(params[:party_id])

        redirect_to action: 'party'
    end

    def pull_user_statuses
      @current_party = get_user_current_party(@user)
      # Because the controller's method is called pull_user_statuses and there is a file pull_user_statuses.json.erb, 
      # the file gets executed. The contents of the file are then returned to the ajax 'success' method
      #This is equalivalent to: render :file => "new_account/pull_user_statuses.json.erb", :content_type => 'application/json'
    end

    def submit_party_invite_request
        friend_first_name = params[:first_name]
        friend_last_name = params[:last_name]
        friend_full_name = friend_first_name + " " + friend_last_name;
        friend_email = params[:email]

        @current_party = get_user_current_party(@user)

        #find the friend
        friend =
        User.where( :email => friend_email ).first ||
        User.where( :secondary_email => friend_email ).first
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
        @current_party = get_user_current_party(@user)
        @current_party_events = @current_party.events.sort_by &:start

        @current_nav_selection = "nav_calendar"
    end
    
    def handle_event_commitment
       event = Event.find(params[:event_id])
       @current_party = get_user_current_party(@user)

       reg = @current_party.get_registration(event.id, @user.id)
       reg.commitment = params[:new_commitment]
       reg.save
       
       redirect_to action: 'calendar'
    end

    def stats
        @current_nav_selection = "nav_stats"
    end

    def chat
        @current_party = get_user_current_party(@user)
        
        #only display the last 20 entries in the chat (maybe a more dynamic scheme in the future)
        @conversations = @current_party.party_conversations.last(20)
        @current_nav_selection = "nav_chat"
    end

    def handle_chat_post
       @current_party = get_user_current_party(@user)

       conversation = PartyConversation.new
       conversation.party_id = @current_party.id
       conversation.message  = params[:message]
       conversation.user_id  = @user.id

       conversation.save

       redirect_to action: 'chat'
    end

    def handle_chat_update
       @current_party = get_user_current_party(@user)

       # there are new messages to display (ie: the front end is not in sync with the back end)
       if @current_party.party_conversations.empty? == false && 
          @current_party.party_conversations.last.id != params[:last_message_id].to_i
           conversations = @current_party.party_conversations.last(20)
           render json: {"reload_page": true}
       else
           #the JQuery is pulling for new messages available
           #redirect_to action: 'chat'
           render json: {"reload_page": false}
       end
    end

    def party
        @current_user_party = get_user_current_party(@user)
        @all_parties = Party.all
        @party_invites = @user.get_all_party_invites

       #only the owner of a party reviews party join requests
        if @user.id == @current_user_party.get_owner.id
          @join_party_requests = @current_user_party.get_all_join_party_requests
        else
          @join_party_requests = Array.new
        end

        @current_nav_selection = "nav_party"
    end

    def feedback
        @current_nav_selection = "nav_feedback"
    end

    def profile
        @current_nav_selection = ""
    end

    def settings
        @current_nav_selection = ""
    end

    def submit_user_feedback
      user_feedback = UserFeedback.new

      user_feedback.sentiment = 0;#by default, at this point we care more about the message

      case params[:issue_type]
        when "feature"
          user_feedback.issue_type = 1000

        when "bug"
          user_feedback.issue_type = 2000

        when "other"
          user_feedback.issue_type = 3000
      end

      user_feedback.email = @user.email
      user_feedback.description = params[:description]

      user_feedback.save
      redirect_to action: 'feedback'
    end

    private

    #this function returns the user's current party
    def get_user_current_party(user)
        # if this is the first time the user logs in (current_party_index nil)
        # if the @user.current_party_index is invalid in any way, this will returns user.pary[0]
        if user.current_party_index.nil? || user.current_party_index >= user.parties.count
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

    # Use callbacks to share common setup or constraints between actions.
    # this is called before any action in the controller is called.
    # here we get the user, and time stamp them. @user is valid in all 
    # controller method.
    def update_user_last_seen
      user_id = session[:user_id]
      user = User.find(user_id)
      user.last_seen = Time.now
      user.save
      @user = user
    end
end

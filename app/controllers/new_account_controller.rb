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

        if params[:from_handle_spotify_auth] == "true"
            @spotify_sync_success = true
            params[:from_handle_spotify_auth] = false # until next time
        end

        if (session.has_key?(:answers))
          self.generate_recommendation_from_quiz(JSON.parse(session[:answers]))
        end

        @num_actions = actions.count

        self.manage_actions_dynamically

        actions_array = actions.to_a

        @questions = Array.new
        @link_tos  = Array.new
        @current_nav_selection = "nav_home"

        #if current user id invalid (party deleted for instance)
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

    def generate_recommendation_from_quiz(answers)
      # In the quiz, we ignore question 2.  We use Question 1 to determine an era of music, and Question 3 to determine how fast paced it should be.
      # Harcoded for now.

      ## TODO: Have to modify the 'populate_db.rake' to add our hardcoded recommendations to the database.
      ## Then we can 

      # Modern music
      if (answers[0] == '0')
        # Modern chill music
        if (answers[2] == '0')
        # Modern fast paced music
        elsif (answers[2] == '1')
        end
      end

    end

    #based on user state (are we missing some information)
    # we might want to assign some actions for the user to do.
    # ie: Update their gender, location, and age (or age group).
    # But also some party related requests might be in their queue
    def manage_actions_dynamically
      inviteLinkto = LinkTo.get_party_invitation_link #this could be nil, remember, we need to create it manually (only once though).
      partyJoinRequestLinkTo = LinkTo.get_request_to_join_party_link #this could be nil, remember, we need to create it manually (only once though).
      syncSpotifyLinkto = LinkTo.get_sync_spotify_link #this could be nil, remember, we need to create it manually (only once though).
      inviteFriendLinkto = LinkTo.get_invite_friend_link #this could be nil, remember, we need to create it manually (only once though).

      #########These stay########
      if syncSpotifyLinkto.nil? == false
        if @user.is_assigned_linkto( syncSpotifyLinkto ) == false #if this is not already assigned
          #create a new action and assign it to the user
          action = UserAction.new
          action.user_id = @user.id
          action.action_type = UserAction.linkto_type
          action.action_id = syncSpotifyLinkto.id
          action.save
        end
      end

      if inviteFriendLinkto.nil? == false
        if @user.is_assigned_linkto( inviteFriendLinkto ) == false #if this is not already assigned
          #create a new action and assign it to the user
          action = UserAction.new
          action.user_id = @user.id
          action.action_type = UserAction.linkto_type
          action.action_id = inviteFriendLinkto.id
          action.save
        end
      end
      ############################

      ######### Optional ########
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

      if @user.any_join_party_requests == true
        if @user.is_assigned_linkto( partyJoinRequestLinkTo ) == false && partyJoinRequestLinkTo != nil
          #create a new action and assign it to the user
          action = UserAction.new
          action.user_id = @user.id
          action.action_type = UserAction.linkto_type
          action.action_id = partyJoinRequestLinkTo.id
          action.save
        end
      else #the invites are empty we might have to remove the linkto
        if @user.is_assigned_linkto( partyJoinRequestLinkTo ) == true
          #remove it
          @user.get_actions.where("action_id" => partyJoinRequestLinkTo.id).delete_all
        end
      end
    ############################
    end

    def enter_answer
        action = UserAction.find(params[:action_id])
        dismiss = false
        if params[:dismiss_button]
            dismiss = true
        end

        if dismiss == false
            questionAnswer = QuestionAnswer.new

            questionAnswer.question_id = action.action_id
            questionAnswer.user_id = session[:user_id]
            questionAnswer.answer_integer = params[:answer_integer]
            questionAnswer.answer_text = params[:answer_text]

            questionAnswer.save!
        end

        action.destroy

        render nothing: true
    end

    def edit_user
        @user.name   = params[:name]
        @user.email  = params[:email]
        @user.secondary_email = params[:secondary_email]
        @user.gender   = params[:gender]
        @user.birthday = params[:birthday]
        digits = (params[:zip_code].to_i == 0) ? 1 : Math.log10(params[:zip_code].to_i) + 1;
        if(digits.to_i == 5)# zip codes are 5 digits long, we still need to make sure it is a valid zip code
            @user.zip_code = params[:zip_code].to_region.nil? == false ? params[:zip_code] : 0
        end
        @user.description = params[:description]
        @user.save

        redirect_to action: 'profile'
    end

    def handle_link_to
        action = UserAction.find( params[:action_id] )
        dismiss = params[:dismiss]

        # Take note of likes/dislikes
        liked = params[:liked]
        if !liked.nil?
            user_id = session[:user_id]
            @metadatum           = UserMetadatum.new
            @metadatum.user_id   = user_id
            @metadatum.data_type = UserMetadatum.type_id_like
            # This values needs to be ordered according to the UserMetadatum::Like module
            @metadatum.data      = action.action_id.to_s + "," + action.action_type.to_s + "," + liked
            @metadatum.save
        end

        #I know, it's weird, but an action can store the ID of a question, or a linkto (or more)
        # and that ID is called action_id. params[:action_id] is the ID of the action the user interacted with.
        linkto = LinkTo.find(action.action_id)
        if linkto.is_standard_linkto && dismiss == "true"
           # these sorts of linktos are disposable, the act of clicking on them warrants their removal
           #(they have been consumed)
          action.destroy
        end

        #if the user clicked the dismiss button, we don't want to redirect to the URL
        if dismiss == "true"
            redirect_to action: 'home'
        else
            redirect_to params[:url]
        end
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
        party_owner = party.get_owner
        #send an email
        Outreach.party_join_request( party, @user, party_owner, "http://www.audicy.us/").deliver_now
      end

      redirect_to action: 'party'
    end

    def handle_user_request_to_join_party
      friend = User.find(params[:user_id])
      @current_party = get_user_current_party(@user)
      if @current_party.users.exists?(friend.id)#sanity check
        return
      end

      if (params[:commit] == "Accept!")
        @current_party.users << friend
      end

      @current_party.remove_party_join_requests(params[:user_id])

      redirect_to action: 'party'
    end

    def join_party
        party = Party.find(params[:party_id])

        #make sure user not already in the party

        if (params[:commit] == "Join!")
          if party.users.exists?(@user.id) == false
              party.users << @user #store user
          end
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
          Outreach.party_invite( @current_party, @user, friend, friend_full_name, friend_email, "http://www.audicy.us/").deliver_now

        end

        redirect_to action: 'party'
    end

    def calendar
        @current_party = get_user_current_party(@user)
        @current_party_events = @current_party.events.sort_by &:start

        #remove events
        now = Time.now()
        @current_party_events.delete_if {|x| x.start < now }

        UserPartyInfo.update_last_seen_event(@user, @current_party)

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
        #only display the last 20 entries in the chat (maybe a more dynamic scheme in the future)
        @conversations = @current_user_party.party_conversations.last(20)

        #store the last message seen by the user in order to display the number of missed messages
        last_conversation = @current_user_party.party_conversations.last
        if last_conversation.nil? == false
            #if there isn't already a last message seen for this user and this party, create one
            last_message_seen = @user.last_seen_party_conversations.where(:party_id => @current_user_party.id).first
            if last_message_seen.nil?
                last_message_seen = LastSeenPartyConversation.new
                last_message_seen.user_id  = @user.id
                last_message_seen.party_id = @current_user_party.id
            end

            #update the id of the message last seen by the user in this party
            last_message_seen.party_conversation_id = last_conversation.id
            last_message_seen.save
        end
        @current_nav_selection = "nav_chat"
    end

    def handle_chat_post
       conversation = PartyConversation.new
       conversation.party_id = @current_user_party.id
       conversation.message  = params[:message]
       conversation.user_id  = @user.id

       conversation.save

       redirect_to action: 'chat'
    end

    def handle_chat_update
       # there are new messages to display (ie: the front end is not in sync with the back end)
       if @current_user_party.party_conversations.empty? == false &&
          @current_user_party.party_conversations.last.id != params[:last_message_id].to_i
           conversations = @current_user_party.party_conversations.last(20)
           render json: {"reload_page": true}
       else
           #the JQuery is pulling for new messages available
           #redirect_to action: 'chat'
           render json: {"reload_page": false}
       end
    end

    def query_missed_messages
        count = @user.get_missed_messages_count
        render json: {"missed_messages_count": count}
    end

    def party
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
      @current_user_party = get_user_current_party(@user)
    end

end

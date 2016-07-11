require 'test_helper'

class NewAccountControllerTest < ActionController::TestCase

    def setup
        session[:user_id] = users(:steve_jobs).id
        session[:fb_info] = Hash.new({
            provider: 'facebook',
            uid: users(:steve_jobs).uid,
            info: {
              first_name: "Test",
              last_name:  "User",
              email:      users(:steve_jobs).email
            },
            credentials: {
              token: "123456",
              expires_at: Time.now + 1.week
            }
        })
    end


    test "Load Home Page" do
        get :home
        assert_response :success
    end

    test "No party invites" do
      # Destroy all invites...
      PartyInvite.where(dst_user_id: users(:steve_jobs).id).destroy_all

      # ...But then artifically assign a party invitation link_to to see if this gets cleaned up

      action = UserAction.new
      action.user_id = users(:steve_jobs).id
      action.action_type = UserAction.linkto_type
      action.action_id = LinkTo.get_party_invitation_link.id
      action.save

      # Similarly destroy all join party requests...
      user = User.find(users(:steve_jobs).id)
      current_party = user.get_owned_parties[user.current_party_index.to_i]

      Rails.logger.debug "foobar"
      Rails.logger.debug user.current_party_index
      Rails.logger.debug current_party

      JoinPartyRequest.where(party_id: current_party.id).destroy_all

      # ...Then artifically assign a party join request
      action = UserAction.new
      action.user_id = users(:steve_jobs).id
      action.action_type = UserAction.linkto_type
      action.action_id = LinkTo.get_request_to_join_party_link.id
      action.save

      get :home
      assert_response :success
    end

end

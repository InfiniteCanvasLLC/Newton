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

      get :home
      assert_response :success
    end

end

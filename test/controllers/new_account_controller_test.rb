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

end

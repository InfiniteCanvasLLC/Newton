require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

    def setup
        OmniAuth.config.test_mode = true

        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
            provider: 'facebook',
            uid: '123545',
            info: {
              first_name: "Test",
              last_name:  "User",
              email:      ENV['FB_TESTUSER_USERNAME']
            },
            credentials: {
              token: ENV['FACEBOOK_AUTHORIZATION_TOKEN'],
              expires_at: Time.now + 1.week
            }
        })

        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    end

    test "Facebook Redirect Path" do
        get :new
        assert_redirected_to '/auth/facebook'
    end

    test "Login with new user" do
        get :create

        user = User.where(email: ENV['FB_TESTUSER_USERNAME'] )
        assert(user != nil, "User was not created")
        assert_redirected_to(controller: 'new_account', action: 'home')
    end

end

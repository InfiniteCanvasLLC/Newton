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
              token: "123456",
              expires_at: Time.now + 1.week
            }
        })

        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]

        puts request.env["omniauth.auth"]
    end

    test "Facebook Redirect Path" do
        get :new
        assert_redirected_to '/auth/facebook'
    end

    test "Login with new user" do
        get :create
    end

end

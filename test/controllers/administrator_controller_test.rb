require 'test_helper'

class AdministratorControllerTest < ActionController::TestCase

    test "administrator root page" do
        session[:user_id] = users(:steve_jobs).id
        get :index
        assert_response :success
    end

    test "administrator root page non_admin" do
        session[:user_id] = users(:steve_wozniak).id
        get :index
        assert_response(500)
    end

end

require 'test_helper'

class AdministratorControllerTest < ActionController::TestCase

    test "root page" do
        get :index
        assert_response :success
    end

end

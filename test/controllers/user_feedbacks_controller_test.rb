require 'test_helper'

class UserFeedbacksControllerTest < ActionController::TestCase

  test "load_page" do
    get :index
    assert_response :success
  end

end
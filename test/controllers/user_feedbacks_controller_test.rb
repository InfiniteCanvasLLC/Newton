require 'test_helper'

class UserFeedbacksControllerTest < ActionController::TestCase

  test "load_page" do
    session[:user_id] = users(:steve_jobs).id
    get :index
    assert_response :success
  end

test "load_page non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    get :index
    assert_response(500)
  end

end
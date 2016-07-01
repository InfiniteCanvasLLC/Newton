require 'test_helper'

class UserActionsControllerTest < ActionController::TestCase
  setup do
    @user_action = user_actions(:one)
  end

  test "should get index" do
    session[:user_id] = users(:steve_jobs).id

    get :index
    assert_response :success
    assert_not_nil assigns(:user_actions)
  end

  test "should get index non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    
    get :index
    assert_response(500)
  end

  test "should get new" do
    session[:user_id] = users(:steve_jobs).id
    get :new
    assert_response :success
  end

  test "should get new non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    get :new
    assert_response(500)
  end

  test "should create user_action" do
    session[:user_id] = users(:steve_jobs).id

    assert_difference('UserAction.count') do
      post :create, user_action: { action_id: @user_action.action_id, action_type: @user_action.action_type, user_id: @user_action.user_id }
    end

    assert_redirected_to user_action_path(assigns(:user_action))
  end

  test "should create user_action non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    
    assert_difference('UserAction.count', 0) do
      post :create, user_action: { action_id: @user_action.action_id, action_type: @user_action.action_type, user_id: @user_action.user_id }
    end

    assert_response(500)
  end

  test "should create invalid user action" do

      post :create, user_action: { action_id: @user_action.action_id, action_type: @user_action.action_type, user_id: 0 }
      assert_response(500)
  end

  test "should show user_action" do
    session[:user_id] = users(:steve_jobs).id
    get(:show, { 'id' => @user_action.id })
    assert_response :success
  end

  test "should show user_action non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    get(:show, { 'id' => @user_action.id })
    assert_response(500)
  end

  test "should get edit" do
    session[:user_id] = users(:steve_jobs).id
    get :edit, id: @user_action
    assert_response :success
  end

  test "should get edit non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    get :edit, id: @user_action
    assert_response(500)
  end

  test "should update user_action" do
    session[:user_id] = users(:steve_jobs).id
    patch :update, id: @user_action, user_action: { action_id: @user_action.action_id, action_type: @user_action.action_type, user_id: @user_action.user_id }
    assert_redirected_to user_action_path(assigns(:user_action))
  end

  test "should update user_action non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    patch :update, id: @user_action, user_action: { action_id: @user_action.action_id, action_type: @user_action.action_type, user_id: @user_action.user_id }
    assert_response(500)
  end

  test "should destroy user_action" do
    session[:user_id] = users(:steve_jobs).id
    assert_difference('UserAction.count', -1) do
      delete :destroy, id: @user_action
    end

    assert_redirected_to user_actions_path
  end

  test "should destroy user_action non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    assert_difference('UserAction.count', 0) do
      delete :destroy, id: @user_action
    end

    assert_response(500)
  end
end

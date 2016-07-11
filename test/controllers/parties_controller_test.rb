require 'test_helper'

class PartiesControllerTest < ActionController::TestCase
  setup do
    @party = parties(:hello_kitty_party)
  end

  test "should get index" do
    session[:user_id] = users(:steve_jobs).id
    get :index
    assert_response :success
    assert_not_nil assigns(:parties)
  end

  test "should get index non-admin" do
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

  test "should create party" do

    session[:user_id] = User.first.id

    assert_difference('Party.count') do
      post :create, party: { name: @party.name }
    end

    assert_redirected_to party_path(assigns(:party))
  end

  test "should fail to create party" do
    post :create, party: { name: @party.name }

    assert_response(500)
  end

  test "should show party" do
    session[:user_id] = users(:steve_jobs).id
    get :show, id: @party
    assert_response :success
  end

  test "should show party non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    get :show, id: @party
    assert_response(500)
  end

  test "should get edit" do
    session[:user_id] = users(:steve_jobs).id
    get :edit, id: @party
    assert_response :success
  end

  test "should get edit non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    get :edit, id: @party
    assert_response(500)
  end

  test "should update party" do
    session[:user_id] = users(:steve_jobs).id
    patch :update, id: @party, party: { name: @party.name }
    assert_redirected_to party_path(assigns(:party))
  end

  test "should update party non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    patch :update, id: @party, party: { name: @party.name }
    assert_response(500)
  end

  test "should destroy party" do
    session[:user_id] = users(:steve_jobs).id
    assert_difference('Party.count', -1) do
      delete :destroy, id: @party
    end

    assert_redirected_to parties_path
  end

  test "view party invites" do
    session[:user_id] = users(:steve_jobs).id
    get :view_party_invites
    assert_response :success
  end

  test "view party invites non-admin" do
    session[:user_id] = users(:steve_wozniak).id
    get :view_party_invites
    assert_response(500)
  end


  test "view join requests" do
    session[:user_id] = users(:steve_jobs).id
    get :view_join_requests
    assert_response :success
  end

  test "view join requests non-admin" do
    session[:user_id] = users(:steve_wozniak).id
    get :view_join_requests
    assert_response(500)
  end

end

require 'test_helper'

class LinkTosControllerTest < ActionController::TestCase
  setup do
    @link_to = link_tos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:link_tos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create link_to" do
    assert_difference('LinkTo.count') do
      post :create, link_to: { description: @link_to.description, icon_style: @link_to.icon_style, link_text: @link_to.link_text, panel_style: @link_to.panel_style, title: @link_to.title, url: @link_to.url }
    end

    assert_redirected_to link_to_path(assigns(:link_to))
  end

  test "should show link_to" do
    get :show, id: @link_to
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @link_to
    assert_response :success
  end

  test "should update link_to" do
    patch :update, id: @link_to, link_to: { description: @link_to.description, icon_style: @link_to.icon_style, link_text: @link_to.link_text, panel_style: @link_to.panel_style, title: @link_to.title, url: @link_to.url }
    assert_redirected_to link_to_path(assigns(:link_to))
  end

  test "should destroy link_to" do
    assert_difference('LinkTo.count', -1) do
      delete :destroy, id: @link_to
    end

    assert_redirected_to link_tos_path
  end
end

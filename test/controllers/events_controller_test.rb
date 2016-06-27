require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:one)
  end

  test "should get index" do
    session[:user_id] = users(:steve_jobs).id

    get :index
    assert_response :success
    assert_not_nil assigns(:events)
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

  test "should create event" do
    session[:user_id] = users(:steve_jobs).id

    assert_difference('Event.count') do
      post :create, event: { description: @event.description, event_type: @event.event_type, metadata: @event.metadata, start: @event.start }
    end

    assert_redirected_to event_path(assigns(:event))
  end

  test "should create event non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    
    assert_difference('Event.count', 0) do
      post :create, event: { description: @event.description, event_type: @event.event_type, metadata: @event.metadata, start: @event.start }
    end

    assert_response(500)
  end

  test "should show event" do
    session[:user_id] = users(:steve_jobs).id

    get :show, id: @event
    assert_response :success
  end

  test "should show event non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    
    get :show, id: @event
    assert_response(500)
  end

  test "should get edit" do
    session[:user_id] = users(:steve_jobs).id

    get :edit, id: @event
    assert_response :success
  end

  test "should get edit non_admin" do
    session[:user_id] = users(:steve_wozniak).id

    get :edit, id: @event
    assert_response(500)
  end

  test "should update event" do
    session[:user_id] = users(:steve_jobs).id

    patch :update, id: @event, event: { description: @event.description, event_type: @event.event_type, metadata: @event.metadata, start: @event.start }
    assert_redirected_to event_path(assigns(:event))
  end

  test "should update event non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    
    patch :update, id: @event, event: { description: @event.description, event_type: @event.event_type, metadata: @event.metadata, start: @event.start }
    assert_response(500)
  end

  test "should destroy event" do
    session[:user_id] = users(:steve_jobs).id

    assert_difference('Event.count', -1) do
      delete :destroy, id: @event
    end

    assert_redirected_to events_path
  end

    test "should destroy event non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    
    assert_difference('Event.count', 0) do
      delete :destroy, id: @event
    end

    assert_response(500)
  end

end

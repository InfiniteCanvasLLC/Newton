require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  setup do
    @question = questions(:ice_cream)
  end

  test "should get index" do
    session[:user_id] = users(:steve_jobs).id

    get :index
    assert_response :success
    assert_not_nil assigns(:questions)
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

  test "should create question" do
    session[:user_id] = users(:steve_jobs).id

    assert_difference('Question.count') do
      post :create, question: { metadata_four: @question.metadata_four, metadata_one: @question.metadata_one, metadata_three: @question.metadata_three, metadata_two: @question.metadata_two, question_type: @question.question_type, text: @question.text }
    end

    assert_redirected_to question_path(assigns(:question))
  end

  test "should create question non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    
    assert_difference('Question.count', 0) do
      post :create, question: { metadata_four: @question.metadata_four, metadata_one: @question.metadata_one, metadata_three: @question.metadata_three, metadata_two: @question.metadata_two, question_type: @question.question_type, text: @question.text }
    end

    assert_response(500)
  end

  test "should show question" do
    session[:user_id] = users(:steve_jobs).id
    get :show, id: @question
    assert_response :success
  end

  test "should show question non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    get :show, id: @question
    assert_response(500)
  end

  test "should get edit" do
    session[:user_id] = users(:steve_jobs).id
    get :edit, id: @question
    assert_response :success
  end

  test "should get edit non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    get :edit, id: @question
    assert_response(500)
  end

  test "should update question" do
    session[:user_id] = users(:steve_jobs).id

    patch :update, id: @question, question: { metadata_four: @question.metadata_four, metadata_one: @question.metadata_one, metadata_three: @question.metadata_three, metadata_two: @question.metadata_two, question_type: @question.question_type, text: @question.text }
    assert_redirected_to question_path(assigns(:question))
  end

  test "should update question non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    
    patch :update, id: @question, question: { metadata_four: @question.metadata_four, metadata_one: @question.metadata_one, metadata_three: @question.metadata_three, metadata_two: @question.metadata_two, question_type: @question.question_type, text: @question.text }
    assert_response(500)
  end

  test "should destroy question" do
    session[:user_id] = users(:steve_jobs).id

    assert_difference('Question.count', -1) do
      delete :destroy, id: @question
    end

    assert_redirected_to questions_path
  end

  test "should destroy question non_admin" do
    session[:user_id] = users(:steve_wozniak).id
    
    assert_difference('Question.count', 0) do
      delete :destroy, id: @question
    end

    assert_response(500)
  end

end

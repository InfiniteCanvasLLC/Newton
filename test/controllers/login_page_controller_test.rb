require 'test_helper'

class LoginPageControllerTest < ActionController::TestCase
  test "Submit User Signup" do
    assert_difference('UserFeedback.count') do
        post :submit_user_signup, email: "steve@apple.com", first_name: "Steve", last_name: "Jobs"
    end
  end

  test "Submit User Feedback" do
    assert_difference('UserFeedback.count') do
        post :submit_user_feedback, sentiment: "good", issue_type: "feature", email: "steve@apple.com", description: "I want free concert tickets"
    end

    assert_difference('UserFeedback.count') do
        post :submit_user_feedback, sentiment: "bad", issue_type: "bug", email: "steve@apple.com", description: "I want free concert tickets"
    end

    assert_difference('UserFeedback.count') do
        post :submit_user_feedback, sentiment: "neutral", issue_type: "other", email: "steve@apple.com", description: "I want free concert tickets"
    end
  end

end

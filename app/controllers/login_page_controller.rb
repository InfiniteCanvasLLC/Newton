class LoginPageController < ApplicationController

  layout "creative"
  
  def submit_user_feedback
    user_feedback = UserFeedback.new
    
    user_feedback.sentiment = params[:sentiment] == "good" ? 1 : 0
    
    case params[:issue_type]
      when "bug"
        user_feedback.issue_type = 0;
      
      when "feature"
        user_feedback.issue_type = 1;
      
      when "other"
        user_feedback.issue_type = 2;
    end
    
    user_feedback.email = params[:email]
    user_feedback.description = params[:description]
    
    user_feedback.save
  end
end

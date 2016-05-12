class LoginPageController < ApplicationController

  layout "creative"
  
  def submit_user_feedback
    user_feedback = UserFeedback.new
    
    user_feedback.sentiment = params[:sentiment] == "good" ? 0 : 1;
    
    case params[:issue_type]
      when "feature"
        user_feedback.issue_type = 1000
      
      when "bug"
        user_feedback.issue_type = 2000
      
      when "other"
        user_feedback.issue_type = 3000      
    end
      
    user_feedback.email = params[:email]
    user_feedback.description = params[:description]
    
    user_feedback.save
    
    render nothing: true
  end
end

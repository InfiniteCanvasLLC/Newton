class LoginPageController < ApplicationController

  layout "creative"

  protect_from_forgery unless: -> { request.format.json? }
  
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
  
  def submit_user_signup
    user_feedback = UserFeedback.new
    
    user_feedback.sentiment = 0
    user_feedback.issue_type = 4000
    user_feedback.email = params[:email]
    user_feedback.description = params[:first_name] + " " + params[:last_name]
    
    user_feedback.save
    
    render nothing: true
  end

  def set_entry_quiz_result
    session[:answers] = params["answers"].to_json

    puts "Setting quiz answers"
    puts "#{session[:answers]}"

    render json: {"success": true}
  end


end

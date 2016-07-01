class UserFeedbacksController < ApplicationController

    before_filter :verify_administrator

    layout "administrator"
  
    # GET /user_feedbacks
    # GET /user_feedbacks.json
    def index
        @current_nav_selection = "nav_user_feedbacks"

        @user_feedbacks = UserFeedback.all
    end
    
end

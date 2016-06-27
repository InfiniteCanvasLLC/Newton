class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	def get_administrator
		
		admin = true

		current_user_id = session[:user_id];

		Rails::logger.debug "User id is"
		Rails::logger.debug current_user_id

		if (current_user_id.nil?)
			admin = false
		end

		Rails::logger.debug "Attempting to look up user"

		current_user = User.find_by_id(current_user_id)

		Rails::logger.debug "Current user is"
		Rails::logger.debug current_user.inspect

		if ((current_user.nil?) || (current_user.permissions.nil?) || ((current_user.permissions & User::PERMISSION_ADMINISTRATOR) == 0))
			admin = false
		end

		return admin

	end

	def verify_administrator
        
        Rails::logger.debug "Request inspect is"
		Rails::logger.debug @request.inspect
		Rails::logger.debug "Params is"
		Rails::logger.debug params.inspect

        if (!get_administrator)
            render(:file => File.join(Rails.root, 'public/500.html'), :status => 500, :layout => false)
        end

    end

end

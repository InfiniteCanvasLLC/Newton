class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	def get_administrator
		
		admin = true

		current_user_id = session[:user_id];

		if (current_user_id.nil?)
			admin = false
		end

		current_user = User.find(current_user_id)

		if ((current_user.nil?) || (current_user.permissions.nil?) || ((current_user.permissions & User::PERMISSION_ADMINISTRATOR) == 0))
			admin = false
		end

		return admin

	end

	def verify_administrator
        
        if (!get_administrator)
            render(:file => File.join(Rails.root, 'public/500.html'), :status => 500, :layout => false)
        end

    end

end

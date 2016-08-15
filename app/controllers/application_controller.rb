class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	def get_administrator
		
		admin = true

		current_user_id = session[:user_id];

		if (current_user_id.nil?)
			admin = false
		else
			current_user = User.find_by_id(current_user_id)

			if ((current_user.nil?) || (current_user.permissions.nil?) || ((current_user.permissions & User::PERMISSION_ADMINISTRATOR) == 0))
				admin = false
			end
		end

		return admin

	end

	def verify_administrator

        if (!get_administrator)
            render(:file => File.join(Rails.root, 'public/500.html'), :status => 500, :layout => false)
        end

    end

    def verify_user

    	if (params[:id].to_i != session[:user_id])
    		if (!get_administrator)
    			render(:file => File.join(Rails.root, 'public/500.html'), :status => 500, :layout => false)
    		end
    	end

    	return true

    end

    # You can't really e-mail multiple users from inside ActionMailer.  Need to do it from within the controller as described
    # in this article: https://subvisual.co/blog/posts/66-sending-multiple-emails-with-actionmailer
    #
    # So adding a helper method here
    def mail_to_party_id(party_id, email_subject, email_body)
        party = Party.find(party_id)

        emails = Array.new

        party.users.each do |user|
            Outreach.mail_to_user(user, email_subject, email_body).deliver_now
        end
   end

end

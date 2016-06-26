class AdministratorController < ApplicationController
    layout "administrator"

    before_filter :verify_administrator

    def verify_administrator
        
        error = false

        current_user_id = session[:user_id];

        if (current_user_id.nil?)
            error = true
        end

        current_user = User.find(current_user_id)

        if ((current_user.nil?) || (current_user.permissions.nil?) || ((current_user.permissions & User::PERMISSION_ADMINISTRATOR) == 0))
            error = true
        end

        if (error)
            render(:file => File.join(Rails.root, 'public/500.html'), :status => 500, :layout => false)
        end

    end

end

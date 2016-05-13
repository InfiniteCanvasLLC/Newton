class SessionsController < ApplicationController

    def new
        redirect_to '/auth/facebook'
    end

    def create
        auth = request.env["omniauth.auth"]
        user = User.where(  :provider => auth['provider'],
                            :uid => auth['uid']).first || User.create_with_omniauth(auth)

        if user.current_party_index.nil?
            user.current_party_index = 0
        end

        #the user is under no party (create a default one)
        if user.parties.count == 0
           default_party = Party.new
           default_party.name = user.name + "'s Party"
           default_party.owner_user_id = user.id
           default_party.save
           user.parties << default_party
        end

        session[:user_id] = user.id
        session[:fb_info] = auth.info

        if (session[:fb_info])["about"].nil?
            (session[:fb_info])["about"] = "Something about yourself"
        end

        redirect_to controller: 'new_account', action: 'home'
    end

    def destroy
        reset_session
        redirect_to root_url, notice => 'Signed out'
    end


end

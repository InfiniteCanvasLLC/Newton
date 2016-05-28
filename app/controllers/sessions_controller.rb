require 'omniauth-oauth2'
require 'rest-client'
class SessionsController < ApplicationController

    def new
        session.clear
        redirect_to '/auth/facebook'
    end

    def create
        puts "SessionsController Create happening"
        auth = request.env["omniauth.auth"]
        user = User.where(  :provider => auth['provider'],
                            :uid => auth['uid']).first || User.create_with_omniauth(auth)

        if user.current_party_index.nil?
            user.current_party_index = 0
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

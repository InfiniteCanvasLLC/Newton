class SessionsController < ApplicationController

    def new
        session.clear
        #redirect_to '/auth/facebook'
        redirect_to '/auth/spotify'
    end

    def create
        puts "SessionsController Create happening"
        auth = request.env["omniauth.auth"]
        user = User.where(  :provider => auth['provider'],
                            :uid => auth['uid']).first || User.create_with_omniauth(auth)

        session[:user_id] = user.id
        session[:fb_info] = auth.info

        if (session[:fb_info])["about"].nil?
            (session[:fb_info])["about"] = "Something about yourself"
        end

        redirect_to controller: 'new_account', action: 'home'
        
        puts "What are you into?  What are your interests?  What is your future?"
        puts user.id
        puts auth.info
        
        puts "gFunc: Grabbing Spotify User"
        spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
        puts "Spotify User Country: " + spotify_user.country #=> "US"
        puts "Spotify User Email: " + spotify_user.email   #=> "example@email.com"
        
        #puts "Spotify User Top Artist: " 
        #top_artists = spotify_user.top_artists
        #puts top_artists.size       #=> 20
        #puts top_artists.first.name #=> "Nine Inch Nails"

        #puts "Spotify User Top Track: " 
        #top_tracks = spotify_user.top_tracks(time_range: 'short_term') 
        #puts top_tracks.first.name #=> "Purple Rain"
        
    end

    def destroy
        reset_session
        redirect_to root_url, notice => 'Signed out'
    end


end

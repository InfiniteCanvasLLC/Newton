require 'rspotify'
require 'omniauth-oauth2'
require 'rest-client'
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
        
        puts "Spotify Artist Search: Tupac..." 
        artists = RSpotify::Artist.search('Tupac')
        puts artists.first.name
        
        #spotify_user.follows?(artists)
        
        puts "Spotify User Top Artist: " 
        #top_artists = spotify_user.top_artists
        
        #def top_artists(limit: 20, offset: 0, time_range: 'medium_term')
        #url = "me/top/artists?limit=#{limit}&offset=#{offset}&time_range=#{time_range}"
        #response = User.oauth_get(@id, url) 
        #return response if RSpotify.raw_response
        #response['items'].map { |i| Artist.new i }
        #end

        #url = "me/top/artists?limit=#{20}&offset=#{0}&time_range=#{'medium_term'}"
        #response = RestClient::get(user.id, url) 

        #puts top_artists.size       #=> 20
        #puts top_artists.first.name #=> "Nine Inch Nails"

        #puts "Spotify User Top Track: " 
        #top_tracks = spotify_user.top_tracks(time_range: 'short_term') 
        #puts top_tracks.first.name #=> "Purple Rain"
        
        spotify_token = auth['credentials']['token']
         
        puts "Creating Spotify Client for " + spotify_token
        config = 
        {
            :access_token => spotify_token,  # initialize the client with an access token to perform authenticated calls
            :raise_errors => true,  # choose between returning false or raising a proper exception when API calls fails

            # Connection properties
            :retries       => 0,    # automatically retry a certain number of times before returning
            :read_timeout  => 10,   # set longer read_timeout, default is 10 seconds
            :write_timeout => 10,   # set longer write_timeout, default is 10 seconds
            :persistent    => false # when true, make multiple requests calls using a single persistent connection. Use +close_connection+ method on the client to manually clean up sockets
        }
        
        client = Spotify::Client.new(config)
        
        # grab track data
        myTracks = client.me_tracks
        
    end

    def destroy
        reset_session
        redirect_to root_url, notice => 'Signed out'
    end


end

module Spotify
    class Client
        def me_top_artists
            run(:get, '/v1/me/top/artists', [200])
        end

        def me_top_tracks
            run(:get, '/v1/me/top/tracks', [200])
        end
    end
end

class SessionsController < ApplicationController

    def new
        redirect_to '/auth/facebook'
    end

    def create
        auth = request.env["omniauth.auth"]
        user = User.where(  :provider => auth['provider'], :uid => auth['uid']).first
        if( user.nil?)
            user = User.create_with_omniauth(auth)
            # new user, send a welcome message (btw I am pretty sure the email field should be valid #VERIFY)
            Outreach.welcome(user).deliver_now
        end

        if user.current_party_index.nil?
            user.current_party_index = 0
            user.save
        end

        session[:user_id] = user.id
        session[:fb_info] = auth.info

        #query some of the user info form FB
        token = auth['credentials']['token']
        facebook = Koala::Facebook::API.new(token)

        #location
        zip = nil
        location_req = facebook.get_object("me?fields=location{location}")
        if (location_req['location'].blank? == false)
            location = location_req['location']['location']
            full_location = location['city'] + ',' + location['state'] + ',' + location['country']
            zip = full_location.to_zip[0] # a city haz many zips, just take first one
        end

        #birthday
        birthday_req = facebook.get_object("me?fields=birthday")
        birthday = birthday_req['birthday'].blank? ? nil : birthday_req['birthday']

        #gender
        gender = -1
        gender_req   = facebook.get_object("me?fields=gender")
        if gender_req['gender'].blank? == false
            if gender_req['gender'] == 'female'
                gender = User.gender_female
            elsif gender_req['gender'] == 'male'
                gender = User.gender_male
            end
        end

        user.gender = (gender != -1) ? gender : user.gender
        user.birthday = (birthday_req['birthday'].blank? == true) ? user.birthday : Date.strptime( birthday_req['birthday'], "%m/%d/%Y" )
        if user.zip_code == 0  && zip != nil# for this, we allow user to give us an exact zip code, only override is user hasn't
            user.zip_code = zip
        end
        user.save

        redirect_to controller: 'new_account', action: 'home'
    end

    def destroy
        reset_session
        redirect_to root_url, notice => 'Signed out'
    end

    def handle_spotify_auth
        auth = request.env["omniauth.auth"]
        spotify_token = auth['credentials']['token']
        
        # Save spotify data to Newton server
        config = 
        {
            :access_token => spotify_token,  # initialize the client with an access token to perform authenticated calls
            :raise_errors => true,  # choose between returning false or raising a proper exception when API calls fails

            # Connection properties
            :retries       => 1,    # automatically retry a certain number of times before returning
            :read_timeout  => 10,   # set longer read_timeout, default is 10 seconds
            :write_timeout => 10,   # set longer write_timeout, default is 10 seconds
            :persistent    => false # when true, make multiple requests calls using a single persistent connection. Use +close_connection+ method on the client to manually clean up sockets
        }
        
        # parse the spotify data for the stuff we want
        client = Spotify::Client.new(config)
        
        # grab top artists and genres
        topArtistsSpotifyData = client.me_top_artists
        
        topArtistsHash = {}
        topGenresArray = []
        topArtistsSpotifyData["items"].each_with_index do |spotifyArtistData, index|
            # create artist hash for database
            artistHash = {}
            artistHash["rank"] = index
            artistHash["spotify_id"] = spotifyArtistData["id"]
            artistHash["name"] = spotifyArtistData["name"]
            artistHash["genres"] = spotifyArtistData["genres"]

            # add this artist to our artist hash (key is the artist ranking.  top arists will be 0)
            topArtistsHash[index] = artistHash

            # add this artists various genres
            spotifyArtistData["genres"].each do |genre|
                unless topGenresArray.include? genre
                    topGenresArray.push(genre)
                end
            end

        end

        #grab top tracks
        topTracksSpotifyData = client.me_top_tracks
        topTracksHash = {}
        topTracksSpotifyData["items"].each_with_index do |spotifyTrackData, index|
            # create track hash for database
            trackHash = {}
            trackHash["rank"] = index
            trackHash["spotify_id"] = spotifyTrackData["id"]
            trackHash["name"] = spotifyTrackData["name"]
            trackHash["album_name"] = spotifyTrackData["album"]["name"]
            trackHash["artist"] = spotifyTrackData["artists"][0]["name"]
            # add this track to our track hash (key is the track ranking.  top track will be 0)
            topTracksHash[index] = trackHash
        end

        # grab top genres
        # convert topArtists to a hash to save to the database
        #topArtistsHash = JSON.parse( topArtists["items"].to_s[1...-1] )
        #topArtistsHash = JSON.parse( topArtists )
        user = User.find( session[:user_id] )
        user.favorite_info.top_artists = topArtistsHash.to_json.to_s
        user.favorite_info.top_songs = topTracksHash.to_json.to_s
        user.favorite_info.top_genre = topGenresArray.to_json.to_s

        user.favorite_info.save

        # take player back to their home page
        redirect_to controller: 'new_account', action: 'home', from_handle_spotify_auth: true
    end

end

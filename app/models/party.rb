class Party < ActiveRecord::Base
    has_and_belongs_to_many :users
    has_and_belongs_to_many :events
    has_many :party_conversations
    has_many :event_registrations
    has_many :party_metadata
    has_many :party_invites
    has_many :join_party_requests
    belongs_to :administrator, class_name: "User"

  # to fix error in <h2>Register for Event</h2>
  def event_id
    ""
  end

  # this function returns a random party name
  def self.random_name
    return (Faker::Hacker.adjective + " " + Faker::Team.creature).split.map(&:capitalize).join(' ') + " " + Faker::Company.suffix
  end

  def get_owner
    return User.find( self.owner_user_id )
  end

  def get_registration(event_id, user_id)
    #for a given pary, for a given user and event, there can be only one registration
    return self.event_registrations.where(:event_id => event_id, :user_id => user_id).first
  end

  def did_user_request_to_join(user_id)
    #return true if the user already registered to join this party
    return JoinPartyRequest.where(:party_id => self.id, :user_id => user_id).empty? == false
  end

  def remove_party_join_requests(user_id)
    JoinPartyRequest.where(:party_id => self.id, :user_id => user_id).delete_all
  end

  def get_all_join_party_requests
    return JoinPartyRequest.where(:party_id => self.id)
  end

  def get_event_registrations(event_id)
    return EventRegistration.where(:event_id => event_id, :party_id => self.id)
  end

  def avg_top_tracks_info
    partyTrackInfo   = {}
    partyTrackInfo["danceability"]       = 0
    partyTrackInfo["energy"]             = 0
    partyTrackInfo["loudness"]           = 0
    partyTrackInfo["speechiness"]        = 0
    partyTrackInfo["acousticness"]       = 0
    partyTrackInfo["instrumentalness"]   = 0
    partyTrackInfo["liveness"]           = 0
    partyTrackInfo["valence"]            = 0
    partyTrackInfo["tempo"]              = 0

    count = 1
    users.each do |user|
      trackInfo = user.get_avg_trop_tracks_info
      if trackInfo != nil
        count++
        partyTrackInfo["danceability"]     += trackInfo["danceability"]
        partyTrackInfo["energy"]           += trackInfo["energy"]
        partyTrackInfo["loudness"]         += trackInfo["loudness"]
        partyTrackInfo["speechiness"]      += trackInfo["speechiness"]
        partyTrackInfo["acousticness"]     += trackInfo["acousticness"]
        partyTrackInfo["instrumentalness"] += trackInfo["instrumentalness"]
        partyTrackInfo["liveness"]         += trackInfo["liveness"]
        partyTrackInfo["valence"]          += trackInfo["valence"]
        partyTrackInfo["tempo"]            += trackInfo["tempo"]
      end
    end

    partyTrackInfo["danceability"]      /= count
    partyTrackInfo["energy"]            /= count
    partyTrackInfo["loudness"]          /= count
    partyTrackInfo["speechiness"]       /= count
    partyTrackInfo["acousticness"]      /= count
    partyTrackInfo["instrumentalness"]  /= count
    partyTrackInfo["liveness"]          /= count
    partyTrackInfo["valence"]           /= count
    partyTrackInfo["tempo"]             /= count

    return partyTrackInfo
  end

  def related_favorite_artists
    artists = Array.new
    users.each do |user|
      user_artists = user.get_related_favorite_artists
      if user_artists.nil? == false
        artists += user_artists
      end
    end
    return artists
  end

  def overlapping_related_artists_with_count
    result = Hash.new
    artists = self.related_favorite_artists
    artists.uniq.map{ |e| [e, artists.count(e)] }.select{ |_,c| c > 1 }.each{ |e,c| result[e] = c }
    return result
  end

  def favorite_artists
    artists = Array.new
    users.each do |user|
      user_artists = user.get_favorite_artists
      if user_artists.nil? == false
        artists += user_artists
      end
    end
    return artists
  end

  def overlapping_artists_with_count
   result = Hash.new
   artists = self.favorite_artists
   artists.uniq.map{ |e| [e, artists.count(e)] }.select{ |_,c| c > 1 }.each{ |e,c| result[e] = c }
   return result
  end

  def favorite_genres
    genres = Array.new
    users.each do |user|
      user_genres = user.get_favorite_genres
      if user_genres.nil? == false
        genres += user_genres
      end
    end
    return genres
  end

  def overlapping_genres_with_count
   result = Hash.new
   genre = self.favorite_genres
   genre.uniq.map{ |e| [e, genre.count(e)] }.select{ |_,c| c > 1 }.each{ |e,c| result[e] = c }
   return result
  end

  #30 mile radius
  def self.party_inclusion_radius
    return 30
  end

  #@remove all party related information (registrations + conversations + party invites)
  def destroy
    EventRegistration.where(:party_id => self.id).delete_all
    PartyConversation.where(:party_id => self.id).delete_all
    PartyInvite.where(:party_id => self.id).delete_all
    super #call the parent's destroy
  end

end

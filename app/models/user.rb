class User < ActiveRecord::Base

  has_and_belongs_to_many :parties, :uniq => true
  has_many :question_answers
  has_one :favorite_info
  before_create :build_default_favorites_info
  has_many :user_metadata
  has_many :last_seen_party_conversations
  has_many :user_actions

  mailkick_user

  PERMISSION_USER          = 0
  PERMISSION_ADMINISTRATOR = 1 << 0

  # http://stackoverflow.com/questions/3808782/rails-best-practice-how-to-create-dependent-has-one-relations
  # required by the has_one relationship otherwise runtime errors occur trying to access user.favorite_info
  private def build_default_favorites_info
    # build default favorites_info instance. Will use default params.
    # The foreign key to the owning User model is set automatically
    build_favorite_info
    #Set default data
    favorite_info.top_artists = ""
    favorite_info.top_songs   = ""
    favorite_info.top_genre   = ""
    favorite_info.user_id     = 0
    true # Always return true in callbacks as the normal 'continue' state
        # Assumes that the default_profile can **always** be created.
        # or
        # Check the validation of the profile. If it is not valid, then
        # return false from the callback. Best to use a before_validation
        # if doing this. View code should check the errors of the child.
        # Or add the child's errors to the User model's error array of the :base
        # error item
  end

  #IDs for genders
  def self.gender_female
    return 0
  end

  def self.gender_male
    return 1
  end


  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']

      if auth['info']
        user.name = auth['info']['name'] || ""
        user.email = auth['info']['email'] || ""
      end
    end
  end

  def party_id
      ""
  end

  def is_female
    return self.gender == User.gender_female
  end

  def question_answers
    QuestionAnswer.where("user_id = " + self.id.to_s)
  end

  def get_actions
    return UserAction.where("user_id = " + self.id.to_s)
  end

  def get_all_party_invites
    return PartyInvite.where(:dst_user_email => self.email) + PartyInvite.where(:dst_user_email => self.secondary_email)
  end

  def remove_party_invites(party_id)
    PartyInvite.where(:party_id => party_id, :dst_user_email => self.email).delete_all
    PartyInvite.where(:party_id => party_id, :dst_user_email => self.secondary_email).delete_all
  end

  def get_owned_parties
    return Party.where(:owner_user_id => self.id)
  end

  def any_join_party_requests
    parties = self.get_owned_parties
    parties.each do |party|
      if JoinPartyRequest.where(:party_id => party.id).empty? == false
        return true
      end
    end
    return false
  end

  def is_assigned_linkto( linkto )
    #sanity check
    if linkto.nil? == true
      return false
    end

    is_assigned = false;
    actions = self.get_actions
    actions.each do |action|
      if action.is_linkto == true #if the action is a linkto_id
        action_linkto = LinkTo.find(action.action_id)
        if action_linkto.id == linkto.id
          is_assigned = true
        end
      end
    end

    return is_assigned
  end

  def get_missed_messages_count
    #for a given party and a given user, there should only be one last seen message
    last_seen = last_seen_party_conversations.where(:party_id => parties[current_party_index].id).first
    last_party_conversation = parties[current_party_index].party_conversations.last

    count = 0
    if last_seen.nil? == false && last_party_conversation.nil? == false
      count = (last_party_conversation.id - last_seen.party_conversation_id)
    end

    return count
  end

  def get_favorite_artists
    artists = nil
    if favorite_info.nil? == false && favorite_info.top_artists.blank? == false
      artists = Array.new
      parsed = JSON.parse(favorite_info.top_artists)
      i = 0
      until i == parsed.count  do
        artists.push( parsed[i.to_s]["name"] )
        i += 1;
      end
    end
    return artists
  end

  def get_favorite_genres
    genres = nil
    if favorite_info.nil? == false && favorite_info.top_genre.blank? == false
      genres = JSON.parse(favorite_info.top_genre)
    end
    return genres
  end

  def party_at_index(party_index)
    if party_index >= parties.count
      return nil;
    else
      return parties[party_index];
    end
  end

  def self.get_user_name_to_id_array
    pairs = Array.new
    User.all.each do |user|
      pair = [user.name, user.id]
      pairs << pair
    end
    return pairs
  end

  @@active_timeout=(300)#5 minutes
  def is_active
    last_seen = self.last_seen

    if (last_seen.nil?)
      return false
    end

    return (Time.now - self.last_seen).to_i < @@active_timeout #5 minutes ago
  end

  def get_distance_from_user(other_user)
    if other_user.zip_code==0 || self.zip_code == 0
      return 0
    end

    source  = other_user.zip_code.to_s.to_latlon.split(',')
    current_location = Geokit::LatLng.new(source[0].to_f, source[1].to_f)
    destination = self.zip_code.to_s.to_latlon

    return current_location.distance_to(destination)
  end

  def get_region
    if self.zip_code != 0
      return self.zip_code.to_s.to_region
    else
      return ""
    end
  end

end

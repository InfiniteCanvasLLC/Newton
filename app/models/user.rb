class User < ActiveRecord::Base

  has_and_belongs_to_many :parties, :uniq => true
  has_many :question_answers
  has_many :user_metadata

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
    return self.gender == 0
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

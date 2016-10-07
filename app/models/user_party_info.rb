class UserPartyInfo < ActiveRecord::Base
  belongs_to :user
  belongs_to :party
  belongs_to :event

  def self.get_unseen_event_count(user, party)
    user_party_info = UserPartyInfo.get_user_party_info(user.id, party.id)
    if party.events.length > 0
      index = user_party_info.event.nil? ? -1 : party.events.find_index(user_party_info.event)
      index ||= -1
      return party.events.length - index - 1;
    end
    return 0
  end

  def self.update_last_seen_event(user, party)
    user_party_info = UserPartyInfo.get_user_party_info(user.id, party.id)
    if party.events.length > 0
      user_party_info.event = party.events.last
      user_party_info.save
    end
  end

  def self.get_user_party_info(user_id, party_id)
    user_party_info = UserPartyInfo.find_by(user_id: user_id, party_id: party_id)
    if user_party_info.nil?
      user_party_info = UserPartyInfo.new
      user_party_info.user_id = user_id
      user_party_info.party_id = party_id
      user_party_info.save
    end
    return user_party_info
  end
end

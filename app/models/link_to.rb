class LinkTo < ActiveRecord::Base
    def get_type_id_string
        case self.type_id
        when LinkTo.standard_type
            return "Standard LinkTo" #Link to youtube, FB, etc...
        #special meaning (ToDos)
        when LinkTo.sync_spotify_type
            return "Sync Spotify info"
        when LinkTo.party_invitaion_type
            return "New party invitation"
        when LinkTo.invite_friend_type
            return "Invite a friend to party"
        when LinkTo.request_to_join_party_type
            return "Request to join party"
        else
            return "UNKNOW"
        end
    end
  
    
  def self.standard_type
    return 0
  end
  
  def self.sync_spotify_type
    return 1
  end
  
  def self.party_invitaion_type
    return 2
  end
  
  def self.invite_friend_type
    return 3
  end
  
  def self.request_to_join_party_type
    return 4
  end
end

class LinkTo < ActiveRecord::Base
    def get_type_id_string
        case self.type_id
        when 0
            return "Standard LinkTo" #Link to youtube, FB, etc...
        #special meaning (ToDos)
        when 1
            return "Sync Spotify info"
        when 2
            return "New party invitation"
        when 3
            return "Invite a friend to party"
        when 4
            return "Request to join party"
        else
            return "UNKNOW"
        end
    end
end

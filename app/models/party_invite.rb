class PartyInvite < ActiveRecord::Base
    belongs_to :party

    def get_party
        return Party.find(self.party_id)
    end
end

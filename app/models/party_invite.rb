class PartyInvite < ActiveRecord::Base
  def get_party
    return Party.find(self.party_id)
  end
end

class JoinPartyRequest < ActiveRecord::Base

  belongs_to :party

  def get_user
    return User.find( self.user_id )
  end

  def get_party
    return Party.find( self.party_id )
  end

end

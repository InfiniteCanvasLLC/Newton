class JoinPartyRequest < ActiveRecord::Base

  def get_user
    return User.find( self.user_id )
  end

end

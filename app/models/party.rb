class Party < ActiveRecord::Base
    has_and_belongs_to_many :users
    has_and_belongs_to_many :events
    has_many :party_conversations
    has_many :event_registrations

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
end

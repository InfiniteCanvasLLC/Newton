class Party < ActiveRecord::Base
    has_and_belongs_to_many :users
    has_and_belongs_to_many :events

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
end

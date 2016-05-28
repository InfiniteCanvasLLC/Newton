class Party < ActiveRecord::Base
    has_and_belongs_to_many :users
    has_and_belongs_to_many :events

  # to fix error in <h2>Register for Event</h2>
  def event_id
    ""
  end
end

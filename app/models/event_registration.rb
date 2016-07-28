class EventRegistration < ActiveRecord::Base
  belongs_to :party
  belongs_to :user
  belongs_to :event

  validates :party, presence: true
  validates :user, presence: true
  validates :event, presence: true

  def self.user_not_going
    return 2
  end

  def self.user_unsure
    return 1
  end
  
  def self.user_going
    return 0
  end

  validates_inclusion_of :commitment, :in => [EventRegistration.user_going, EventRegistration.user_unsure, EventRegistration.user_not_going]

  
  def is_user_not_going
    return self.commitment == EventRegistration.user_not_going
  end

  def is_user_unsure
    return self.commitment == EventRegistration.user_unsure
  end
  
  def is_user_going
    return self.commitment == EventRegistration.user_going
  end
  
  def get_label_string
    case self.commitment
    when 0
      return "label-success"
    when 1
      return "label-warning"
    when 2
      return "label-danger" 
    end
  end
  
  def get_display_string
    case self.commitment
    when 0
      return "Going"
    when 1
      return "Unsure"
    when 2
      return "Not Going" 
    end
  end

  def get_user
    return User.find(self.user_id)
  end

  def get_event
     return Event.find(self.event_id)
  end

end

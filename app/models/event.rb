class Event < ActiveRecord::Base
    has_and_belongs_to_many :parties
    validate :valid_event_type

    # We don't have any event types, so this should always be nil for now.  Otherwise we might introduce garbage values that have the wrong meaning later
    def valid_event_type
        if (!self.event_type.nil?)
            errors.add(:event_type, "Event type must be nil")
        end
    end
end

class Event < ActiveRecord::Base
    has_and_belongs_to_many :parties
    validate :valid_event_type
    validate :valid_parties
    validates_datetime :start

    # We don't have any event types, so this should always be nil for now.  Otherwise we might introduce garbage values that have the wrong meaning later
    def valid_event_type
        if (!self.event_type.nil?)
            errors.add(:event_type, "Event type must be nil")
        end
    end

    def valid_parties

        self.parties.each do |cur_party|
            if (!Party.exists?(cur_party.id))
                errors.add(:invalid_party, "Attempting to add an invalid party")
            end
        end
    end

end

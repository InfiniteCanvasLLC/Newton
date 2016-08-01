require 'test_helper'

class EventTest < ActiveSupport::TestCase

    test "Party validations" do
        test_event = Event.new

        test_event.start = DateTime.now
        test_event.parties << Party.create(:id => 5)
        Party.destroy(5)

        test_event.save
        
        assert_not(test_event.valid?)


        test_event = Event.create(:start => "invalid_date")
        assert_not(test_event.valid?)


        test_event = Event.new

        test_event.start = DateTime.now
        test_event.parties << Party.create(:id => 5)

        test_event.save

        assert(test_event.valid?)

    end

end

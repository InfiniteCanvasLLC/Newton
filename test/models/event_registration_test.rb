require 'test_helper'

class EventRegistrationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Event and party validation" do
    event = EventRegistration.create(:party_id => 1, :user_id => 1, :event_id => 1)
    assert_not(event.valid?)

    event = EventRegistration.create(:party_id => parties(:hello_kitty_party).id)
    assert_not(event.valid?)

    event = EventRegistration.create(:party_id => parties(:hello_kitty_party).id, :user_id => users(:steve_wozniak).id)
    assert_not(event.valid?)

    event = EventRegistration.create(:party_id => parties(:hello_kitty_party).id, :user_id => users(:steve_wozniak).id, :event_id => events(:one).id, :commitment => 4)
    assert_not(event.valid?)

    event = EventRegistration.create(:party_id => parties(:hello_kitty_party).id, :user_id => users(:steve_wozniak).id, :event_id => events(:one).id, :commitment => EventRegistration.user_going)
    assert(event.valid?)

  end
end

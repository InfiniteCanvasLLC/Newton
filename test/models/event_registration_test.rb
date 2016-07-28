require 'test_helper'

class EventRegistrationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Event and party validation" do
    event = EventRegistration.create(:party_id => 1)
    assert_not(event.valid?)

    event = EventRegistration.create(:party_id => parties(:hello_kitty_party).id)
    assert_not(event.valid?)

    event = EventRegistration.create(:party_id => parties(:hello_kitty_party).id, :user_id => users(:steve_wozniak).id)
    assert(event.valid?)

  end
end

require 'test_helper'
require 'outreach'

class OutreachTest < ActionMailer::TestCase
  test "welcome" do
    user = User.where(email: "support@audicy.us").first
    Outreach.welcome(user).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?
  end

end

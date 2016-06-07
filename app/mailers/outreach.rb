class Outreach < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.outreach.new_user.subject
  #
  def welcome(user)
    @header_message = "Hi " + user.name
    @message = "Thank you for joining the Newton family! We look forward to introducing you and your party to talented local artists!"
    @footer_message = "Your friends at Audicy :) "
    mail to: user.email
  end

  def party_invite(party, src, dest_name, dest_email, link)
    @header_message = "Hi " + dest_name
    @message = "Your friend " + src.name + " would like to invite you to their party " + party.name + "!\n\n"
    @link = link
    @footer_message = "Your friends at Audicy :) "
    mail to: dest_email
  end
end

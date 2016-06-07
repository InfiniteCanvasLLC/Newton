class Outreach < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.outreach.new_user.subject
  #
  def welcome(user)
    @header_message = "Hi " + user.name
    @message = "Thank you for joining the Newton family! We look forward to introducing you and your party to talented local artists!"
    @footer_message = "Your friends at Newton :) "
    mail to: user.email
  end

  def mail_to_user(user_id, email_subject, email_body)
    user = User.find(user_id)

    @header_message = "Hi " + user.name
    @message = email_body
    @footer_message = "Your friends at Newton :) "

    mail to: user.email, subject: email_subject
  end

  def mail_to_party(party_id, email_subject, email_body)
    party = Party.find(party_id)
    emails = Array.new
    party.users.each do |user|
      emails << user.email
    end

    @header_message = "Hi " + party.name
    @message = email_body
    @footer_message = "Your friends at Newton :) "

    mail to: emails, subject: email_subject
  end

end

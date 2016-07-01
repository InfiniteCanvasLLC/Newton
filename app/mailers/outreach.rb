class Outreach < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.outreach.new_user.subject
  #
  def welcome(user)
    mail_to_user(user, "Welcome!", "Thank you for joining the Audicy family! We look forward to introducing you and your party to talented local artists!")
  end

  def party_invite(party, src, dest_name, dest_email, link)
    @header_message = "Hi " + dest_name
    @message = "Your friend " + src.name + " would like to invite you to their party " + party.name + "!\n\n"
    @link = link
    @footer_message = "Your friends at Audicy :) "
    mail to: dest_email
  end

  def party_join_request(party, src, dest_name, dest_email, link)
    @header_message = "Hi " + dest_name
    @message = src.name + " would like to join your party " + party.name + "!\n\n"
    @link = link
    @footer_message = "Your friends at Audicy :) "
    mail to: dest_email
  end

  def mail_to_user_id(user_id, email_subject, email_body)
    user = User.find(user_id)
    mail_to_user(user, email_subject, email_body)
  end

  def mail_to_user(user, email_subject, email_body)
    mail_to(user.email, email_subject, "Hi " + user.name, email_body)
  end

  def mail_to_party_id(party_id, email_subject, email_body)
    party = Party.find(party_id)
    mail_to_party(party, email_subject, email_body)
  end

  def mail_to_party(party, email_subject, email_body)
    emails = Array.new
    party.users.each do |user|
      emails << user.email
    end

    mail_to(emails, email_subject, "Hi " + party.name, email_body)
  end

  def mail_to(email_address, email_subject, email_header, email_body)
    @header_message = email_header
    @message = email_body
    @footer_message = "Your friends at Audicy :)"
    mail to: email_address, subject: email_subject, template_name: "mail_to"
  end

end

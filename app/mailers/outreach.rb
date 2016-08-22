class Outreach < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.outreach.new_user.subject
  #
  def welcome(user)
    mail_to_user(user, "Welcome!", "Thank you for joining the Audicy family! We look forward to introducing you and your party to talented local artists!")
  end

  def party_invite(party, src_user, dest_user, dest_name, dest_email, link)

    if (!dest_user.nil? && dest_user.opted_out?)
      return
    end

    @header_message = "Hi " + dest_name
    @message = "Your friend " + src_user.name + " would like to invite you to their party " + party.name + "!\n\n"
    @link = link
    @footer_message = "Your friends at Audicy :) "
    mail to: dest_email
  end

  def party_join_request(party, src_user, dest_user, link)

    if (dest_user.opted_out?)
      return
    end

    @header_message = "Hi " + dest_user.name
    @message = src_user.name + " would like to join your party " + party.name + "!\n\n"
    @link = link
    @footer_message = "Your friends at Audicy :) "
    mail to: dest_user.email, template_name: "mail_to"
  end

  def mail_to_user_id(user_id, email_subject, email_body)
    user = User.find(user_id)
    mail_to_user(user, email_subject, email_body)
  end

  def mail_to_user(user, email_subject, email_body)

    if (user.opted_out?)
      return
    end
    
    mail_to(user.email, email_subject, "Hi " + user.name, email_body)
  end

  def mail_to(email_address, email_subject, email_header, email_body)
    @header_message = email_header
    @message = email_body
    @footer_message = "Your friends at Audicy :)"
    mail to: email_address, subject: email_subject, template_name: "mail_to"
  end

  def notify_stale_parties(admin, stale_parties)
    @admin = admin
    @parties = stale_parties

    mail to: admin.email, subject: "Stale Parties", template_name: "stale_party_notification"
  end

end

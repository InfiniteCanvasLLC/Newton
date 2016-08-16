class Outreach < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.outreach.new_user.subject
  #
  def welcome(user)
    mail_to_user(user, "Welcome!", "Thank you for joining the Audicy family! We look forward to introducing you and your party to talented local artists!")
  end

  def event_registration(party)
      self.mail_to_party_id(party.id, "Event registration",
      "We have found an event your party " + party.name + " might be interested in. You can find it on your calendar.\nCheck it out on Audicy.us")
  end

  def action_assigned(user_action)
    if user_action.is_question() == true
      self.mail_to_user_id(user_action.user_id, "Quick question",
      "We have assigned you a small question. You can find it on your home page. Please take the time to answer it as it will improve our recommendation.\nCheck it out on Audicy.us")
    elsif user_action.is_linkto() == true
      self.mail_to_user_id(user_action.user_id, "Check it out",
      "We have found something you might be interested in. You can find it on your home page.\nCheck it out on Audicy.us")
    end
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

end

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
      "Audicy found an event that your party " + party.name + " might be interested in. You can find it on your 'Music Events' page.\nCheck it out on Audicy.us")
  end

  def action_assigned(user_action)
    if user_action.is_question() == true
      self.mail_to_user_id(user_action.user_id, "Quick question",
      "Audicy has a quick question waiting for you on your 'Home' page. Stop by and give your answer. Each new answer helps improve Audicy's recommendations.\nCheck it out on Audicy.us")
    elsif user_action.is_linkto() == true
      self.mail_to_user_id(user_action.user_id, "Check it out",
      "Audicy found something you might be interested in. You can find it on your 'Home' page.\nCheck it out on Audicy.us")
    end
  end

  def party_invite(party, src_user, dest_user, dest_name, dest_email, link)

    if (!dest_user.nil? && dest_user.opted_out?)
      return
    end

    @header_message = "Hi " + dest_name
    @message = "Your friend " + src_user.name + " has invited you to join their party " + party.name + "!\n\n"
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


  ###########Quick Tip Emails#################
  @@quick_tip_invite_friend   = 0
  @@quick_tip_answer_question = 1
  @@quick_tip_checkout_song   = 2
  @@quick_tip_sync_spotify    = 3
  @@quick_tip_profile         = 4
  @@quick_tip_events          = 5
  @@quick_tip_switch_party    = 6

  def self.get_quick_tip_list
    return [
    ["Invite a friend", @@quick_tip_invite_friend],
    ["Answer question", @@quick_tip_answer_question],
    ["Checkout song",   @@quick_tip_checkout_song],
    ["Sync Spotify",    @@quick_tip_sync_spotify],
    ["Profile",         @@quick_tip_profile],
    ["Events",          @@quick_tip_events],
    ["Switch Party",    @@quick_tip_switch_party],
    ]
  end

  #These are characterized by a good use of images to convey information
  def self.send_quick_tip(quick_tip_type, user_id)
    user = User.find(user_id)
    if user.nil? == false
      case quick_tip_type.to_i
        when @@quick_tip_invite_friend
          return quick_tip_invite_friend(user.email)
        when @@quick_tip_answer_question
          return quick_tip_answer_question(user.email)
        when @@quick_tip_checkout_song
          return quick_tip_checkout_song(user.email)
        when @@quick_tip_sync_spotify
          return quick_tip_sync_spotify(user.email)
        when @@quick_tip_profile
          return quick_tip_profile(user.email)
        when @@quick_tip_events
          return quick_tip_events(user.email)
        when @@quick_tip_events
          return quick_tip_events(user.email)
        when @@quick_tip_switch_party
          return quick_tip_switch_party(user.email)
      end
    end
    return nil
  end

  def quick_tip_invite_friend(email_address)
    @message1 = "Remember to build your party by inviting friends!"
    @image_url1 = ActionController::Base.helpers.image_url('QuickTips/InviteAFriend/Invite_a_friend_1.png')

    @message2 = "At the top of your 'Party' page you will find the 'Invite' button."
    @image_url2 = ActionController::Base.helpers.image_url('QuickTips/InviteAFriend/Invite_a_friend_2.png')

    @message3 = "Fill out the quick form, and your friend will get notified."
    @image_url3 = ActionController::Base.helpers.image_url('QuickTips/InviteAFriend/Invite_a_friend_3.png')

    mail to: email_address, subject: "Audicy Quick Tip", template_name: "email_tip"
  end
  def quick_tip_answer_question(email_address)
    @message1 = "Audicy will periodically ask you questions about your musical tastes. Each answer you give helps Audicy improve its recommendations!"
    @image_url1 = ActionController::Base.helpers.asset_path('QuickTips/AnswerAQuestion/question.png')
    mail to: email_address, subject: "Audicy Quick Tip", template_name: "email_tip"
  end
  def quick_tip_checkout_song(email_address)
    @message1 = "Audicy will periodically have artist and song recommendations for you! Don't forget to stop in and check them out. Just press play and listen!"
    @image_url1 = ActionController::Base.helpers.asset_path('QuickTips/CheckoutSong/checkout_song.png')
    mail to: email_address, subject: "Audicy Quick Tip", template_name: "email_tip"
  end
  def quick_tip_sync_spotify(email_address)
    @message1 = "Audicy uses Spotify to learn more about your favorite musical genres, artists and songs."
    @image_url1 = ActionController::Base.helpers.asset_path('spotify.jpg')
    @message2 = "This information helps improve Audicy's recommendations for you!"
    @image_url2 = ActionController::Base.helpers.asset_path('QuickTips/SynSpotify/pull_spotify_info.png')

    @message3 = "Remember to periodically click 'pull' to make sure Audicy is up to date with your latest favorites!"
    mail to: email_address, subject: "Audicy Quick Tip", template_name: "email_tip"
  end

  def quick_tip_profile(email_address)
    @message1 = "Audicy needs to know a little bit about you in order to give you the best concert recommendations. You can edit your information from the profile menu"
    @image_url1 = ActionController::Base.helpers.asset_path('QuickTips/Profile/profile_1.png')
    @message2 = "Any information you share helps Audicy work for you. For example, knowing the region where you live let's Audicy find concerts in your area."
    @image_url2 = ActionController::Base.helpers.asset_path('QuickTips/Profile/profile_2.png')
    @message3 = "Information like a secondary email address helps friends find and join your party."
    mail to: email_address, subject: "Audicy Quick Tip", template_name: "email_tip"
  end

  def quick_tip_events(email_address)
    @message1 = "When Audicy finds an event it thinks your party will enjoy it will assign it to you. Check out the 'Music Events' page to see events currently assigned to your party."
    @image_url1 = ActionController::Base.helpers.asset_path('QuickTips/Events/event_page.png')
    @message2 = "The artist, venue and date are displayed on the event. For more information or to purchase tickets click on the 'Tickets' button."
    @image_url2 = ActionController::Base.helpers.asset_path('QuickTips/Events/event_tickets.png')
    @message3 = "You can easily see which of your friends are going to the event and let them know your interest. Just click on the icon on the right to change your status to 'Going', 'Unsure' or 'Not Going'."
    @image_url3 = ActionController::Base.helpers.asset_path('QuickTips/Events/event_interest.png')
    mail to: email_address, subject: "Audicy Quick Tip", template_name: "email_tip"
  end

  def quick_tip_switch_party(email_address)
    @message1 = "At any time you can switch between the your parties from the 'Home' page."
    @image_url1 = ActionController::Base.helpers.asset_path('QuickTips/SwitchParty/switch_party.png')
    @message2 = "Remember that the 'Music Events' and 'Chat' pages are linked to you currently selected party. Any time you switch parties the information on these pages update to match."
    @image_url2 = ActionController::Base.helpers.asset_path('QuickTips/SwitchParty/event.png')
    @image_url3 = ActionController::Base.helpers.asset_path('QuickTips/SwitchParty/chat.png')
    mail to: email_address, subject: "Audicy Quick Tip", template_name: "email_tip"
  end
  ############################################

end

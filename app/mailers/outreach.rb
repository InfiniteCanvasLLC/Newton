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
  def self.get_quick_tip_list
    return [
    ["Invite a friend", @@quick_tip_invite_friend],
    ["Answer question", @@quick_tip_answer_question],
    ["Checkout song",   @@quick_tip_checkout_song],
    ["Sync Spotify",    @@quick_tip_sync_spotify],
    ["Profile",         @@quick_tip_profile],
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
      end
    end
    return nil
  end

  def quick_tip_invite_friend(email_address)
    @message1 = "Remember to grow your party by inviting friends!"
    @image_url1 = ActionController::Base.helpers.image_url('QuickTips/InviteAFriend/Invite_a_friend_1.png')

    @message2 = "At the top of your Party page you will find the Invite button."
    @image_url2 = ActionController::Base.helpers.image_url('QuickTips/InviteAFriend/Invite_a_friend_2.png')

    @message3 = "Fill out the quick form, and your friend will get notified."
    @image_url3 = ActionController::Base.helpers.image_url('QuickTips/InviteAFriend/Invite_a_friend_3.png')

    mail to: email_address, subject: "Audicy Quick Tip", template_name: "email_tip"
  end
  def quick_tip_answer_question(email_address)
    @message1 = "We will periodically ask you a few questions about your musical tastes. Remember to answer them, it helps us improve our recommendations!"
    @image_url1 = ActionController::Base.helpers.asset_path('QuickTips/AnswerAQuestion/question.png')
    mail to: email_address, subject: "Audicy Quick Tip", template_name: "email_tip"
  end
  def quick_tip_checkout_song(email_address)
    @message1 = "We will periodically assign to you artists and songs to check out! Don't forget to take a listen. Just press play!"
    @image_url1 = ActionController::Base.helpers.asset_path('QuickTips/CheckoutSong/checkout_song.png')
    mail to: email_address, subject: "Audicy Quick Tip", template_name: "email_tip"
  end
  def quick_tip_sync_spotify(email_address)
    @message1 = "We use Spotify to learn more about your musical tastes, what genre you like, what are your top artists."
    @image_url1 = ActionController::Base.helpers.asset_path('spotify.jpg')
    @message2 = "If you grant us access to this information we can dramatically improve our recommendations!"
    @image_url2 = ActionController::Base.helpers.asset_path('QuickTips/SynSpotify/pull_spotify_info.png')

    @message3 = "Remember to periodically click 'pull' to make sure we have your latest Spotify information!"
    mail to: email_address, subject: "Audicy Quick Tip", template_name: "email_tip"
  end

  def quick_tip_profile(email_address)
    @message1 = "We need to know a little bit about you in order to give you relevant concert recommendations. You can edit that information from the profile menu"
    @image_url1 = ActionController::Base.helpers.asset_path('QuickTips/Profile/profile_1.png')
    @message2 = "Any information your which to share is very useful to us. For instance by knowing the region where you live, we can lookup the specific concerts in your area."
    @image_url2 = ActionController::Base.helpers.asset_path('QuickTips/Profile/profile_2.png')
    @message3 = "We can also use information like your secondary email address to make sure your friends can easily find you, and send you requests."
    mail to: email_address, subject: "Audicy Quick Tip", template_name: "email_tip"
  end
  ############################################

end

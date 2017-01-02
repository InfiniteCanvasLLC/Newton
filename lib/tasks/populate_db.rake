namespace :populate_db do
  task :create_linktos => :environment do
    inviteLinkto           = LinkTo.get_party_invitation_link
    partyJoinRequestLinkTo = LinkTo.get_request_to_join_party_link
    syncSpotifyLinkto      = LinkTo.get_sync_spotify_link
    inviteFriendLinkto     = LinkTo.get_invite_friend_link

    #This linkto encourages users to invite friends to their party
    if inviteFriendLinkto == nil
      puts "LinkTo.invite_friend_type missing, creating it."
      #create it
      inviteFriendLinkto             = LinkTo.new
      inviteFriendLinkto.title       = "Invite a friend!"
      inviteFriendLinkto.description = "Invite friends to join your party. We combine your musical tastes and find shows you can all enjoy. The more the merrier :)"
      inviteFriendLinkto.url         = "/Party"
      inviteFriendLinkto.link_text   = "invite"
      inviteFriendLinkto.icon_style  = "fa-user-plus"
      inviteFriendLinkto.panel_style = "panel-info"
      inviteFriendLinkto.type_id     = LinkTo.invite_friend_type
      inviteFriendLinkto.save
    end

    #This linkto encourages users to sync their sportify info
    if syncSpotifyLinkto == nil
      puts "LinkTo.sync_spotify_type missing, creating it."
      #create it
      syncSpotifyLinkto             = LinkTo.new
      syncSpotifyLinkto.title       = "Pull Spotify info"
      syncSpotifyLinkto.description = "We can pull your music information and improve our recomendations"
      syncSpotifyLinkto.url         = "/auth/spotify"
      syncSpotifyLinkto.link_text   = "pull"
      syncSpotifyLinkto.icon_style  = "fa-spotify"
      syncSpotifyLinkto.panel_style = "panel-green"
      syncSpotifyLinkto.type_id     = LinkTo.sync_spotify_type
      syncSpotifyLinkto.save
    end

    #This linkto lets the user know they have a party invitation pending (someone invited them)
    if inviteLinkto == nil
      puts "LinkTo.party_invitation_type missing, creating it."
      #create it
      inviteLinkto             = LinkTo.new
      inviteLinkto.title       = "Join a new party!"
      inviteLinkto.description = "Someone invited you to join their party. Go check it out! :)"
      inviteLinkto.url         = "/Party"
      inviteLinkto.link_text   = "see"
      inviteLinkto.icon_style  = "fa-users"
      inviteLinkto.panel_style = "panel-info"
      inviteLinkto.type_id     = LinkTo.party_invitation_type
      inviteLinkto.save
    end

    #This linkto lets the user know they someone wants to join their party
    if partyJoinRequestLinkTo == nil
      puts "LinkTo.request_to_join_party_type missing, creating it."
      #create it
      partyJoinRequestLinkTo             = LinkTo.new
      partyJoinRequestLinkTo.title       = "Join Party Request"
      partyJoinRequestLinkTo.description = "A friend wants to join your party. Go welcome them! :)"
      partyJoinRequestLinkTo.url         = "/Party"
      partyJoinRequestLinkTo.link_text   = "see"
      partyJoinRequestLinkTo.icon_style  = "fa-users"
      partyJoinRequestLinkTo.panel_style = "panel-yellow"
      partyJoinRequestLinkTo.type_id     = LinkTo.request_to_join_party_type
      partyJoinRequestLinkTo.save
    end

  end

  def create_linkto_for_youtube(title, youtube_url)

    linkto = LinkTo.where(title: title, url: youtube_url)

    if (!linkto.empty?)
      return linkto.first
    end

    linkto = LinkTo.new

    linkto.title = title
    linkto.url = youtube_url
    linkto.link_text = "Watch"
    linkto.icon_style = "fa-youtube"
    linkto.panel_style = "panel-red"
    linkto.type_id = LinkTo.standard_type

    linkto.save

    return linkto
  end

  def assign_quiz_recommendation(linkto, question_one, question_three)
    quiz_recommendation = QuizRecommendation.new

    quiz_recommendation.question_one_answer = question_one
    quiz_recommendation.question_three_answer = question_three
    quiz_recommendation.link_to_id = linkto.id

    quiz_recommendation.save
  end

  task :create_quiz_recommendations => :environment do

    # Q1 = 0, Q3 = 0.  This corresponds to 2000s chill music
    linkto = create_linkto_for_youtube("Sia - Cheap Thrills", "https://www.youtube.com/embed/31crA53Dgu0")
    assign_quiz_recommendation(linkto, 0, 0)

    # Q1 = 0, Q3 = 1.  This corresponds to 90s chill.
    linkto = create_linkto_for_youtube("Santana - Smooth ft. Rob Thomas", "https://www.youtube.com/embed/6Whgn_iE5uc")
    assign_quiz_recommendation(linkto, 1, 0)

    # Q1 = 0, Q3 = 2.  This corresponds to 80s chill.
    linkto = create_linkto_for_youtube("a-ha - Take On Me", "https://www.youtube.com/embed/djV11Xbc914")
    assign_quiz_recommendation(linkto, 2, 0)

    # Q1 = 0, Q3 = 3.  This corresponds to 70s chill.
    linkto = create_linkto_for_youtube("Carole King - It's Too Late", "https://www.youtube.com/embed/VkKxmnrRVHo")
    assign_quiz_recommendation(linkto, 3, 0)

    
    # Q1 = 1, Q3 = 0.  This corresponds to modern EDM
    linkto = create_linkto_for_youtube("Tiesto & Mike Williams - I Want You", "https://www.youtube.com/embed/OkAPoah5MTI")
    assign_quiz_recommendation(linkto, 0, 1)

    # Q1 = 1, Q3 = 1.  This corresponds to 90s fast paced music
    linkto = create_linkto_for_youtube("Rage Against The Machine - Killing In The Name", "https://www.youtube.com/embed/bWXazVhlyxQ")
    assign_quiz_recommendation(linkto, 1, 1)

    # Q1 = 1, Q3 = 2.  80s fast paced.
    linkto = create_linkto_for_youtube("Living Color - Cult of Personality", "https://www.youtube.com/embed/7xxgRUyzgs0")
    assign_quiz_recommendation(linkto, 1, 2)

    # Q1 = 1. Q3 = 3.  70s fast paced.
    linkto = create_linkto_for_youtube("Aerosmith - Walk This Way", "https://www.youtube.com/embed/bKttENbsoyk")
    assign_quiz_recommendation(linkto, 1, 2)

  end

end
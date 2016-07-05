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
end
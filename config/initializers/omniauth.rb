Rails.application.config.middleware.use OmniAuth::Builder do
          puts "begin I AM DEBUGGIN NOW"

  puts ENV['FACEBOOK_KEY']
  puts ENV['FACEBOOK_SECRET']
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
           :scope => 'email,user_birthday', :display => 'popup'

  puts ENV['SPOTIFY_ID']
  puts ENV['SPOTIFY_SECRET']
  puts ENV['OAUTH_DEBUG']
          puts "end I AM DEBUGGIN NOW"


  provider :spotify, ENV['SPOTIFY_ID'],  ENV['SPOTIFY_SECRET'], 
           :scope => 'user-library-read user-top-read playlist-read-private user-read-private user-read-email'

end

Rails.application.config.middleware.use OmniAuth::Builder do

  puts "Facebook Key: " + ENV['FACEBOOK_KEY']
  puts "Facebook Secret: " + ENV['FACEBOOK_SECRET']
  puts "Spotify ID: " + ENV['SPOTIFY_ID']
  puts "Spotify Secret: " + ENV['SPOTIFY_SECRET']
  
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
           :scope => 'email,user_birthday', :display => 'page'

  provider :spotify, ENV['SPOTIFY_ID'],  ENV['SPOTIFY_SECRET'], 
           :scope => 'user-library-read user-top-read playlist-read-private user-read-private user-read-email'

end

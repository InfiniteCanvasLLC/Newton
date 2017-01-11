Rails.application.config.middleware.use OmniAuth::Builder do

  puts "Facebook Key: " + ENV['FACEBOOK_KEY']
  puts "Facebook Secret: " + ENV['FACEBOOK_SECRET']
  puts "Spotify ID: " + ENV['SPOTIFY_ID']
  puts "Spotify Secret: " + ENV['SPOTIFY_SECRET']
  puts "Google Analytics ID: " + ENV['GOOGLE_ANALYTICS_ID']
  puts "Mixpanel ID: " + ENV['MIXPANEL_ID']
  
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
           :scope => 'email,user_birthday,public_profile,user_location', :display => 'page', :secure_image_url => true, :provider_ignores_state => true

  provider :spotify, ENV['SPOTIFY_ID'],  ENV['SPOTIFY_SECRET'], 
           :scope => 'user-library-read user-top-read playlist-read-private user-read-private user-read-email'

end

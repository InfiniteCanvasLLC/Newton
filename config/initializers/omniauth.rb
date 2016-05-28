Rails.application.config.middleware.use OmniAuth::Builder do

  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
           :scope => 'email,user_birthday', :display => 'popup'

  provider :spotify, ENV['SPOTIFY_ID'],  ENV['SPOTIFY_SECRET'], 
           :scope => 'user-library-read user-top-read playlist-read-private user-read-private user-read-email'

end

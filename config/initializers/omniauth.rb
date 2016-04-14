Rails.application.config.middleware.use OmniAuth::Builder do
  puts ENV['FACEBOOK_KEY']
  puts ENV['FACEBOOK_SECRET']
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
           :scope => 'email,user_birthday', :display => 'popup'
end

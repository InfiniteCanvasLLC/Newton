# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( login_page/js/jquery.fittext.js )
Rails.application.config.assets.precompile += %w( login_page/js/jquery.easing.min.js )
Rails.application.config.assets.precompile += %w( login_page/js/wow.min.js )
Rails.application.config.assets.precompile += %w( login_page/js/creative.js )
Rails.application.config.assets.precompile += %w( login_page/js/cbpAnimatedHeader.js )
Rails.application.config.assets.precompile += %w( login_page/js/classie.js )
Rails.application.config.assets.precompile += %w( creative/manifest.js creative/manifest.css )

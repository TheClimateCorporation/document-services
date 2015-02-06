# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( lib/shred.bundle.js lib/jquery.slideto.min.js lib/jquery.wiggle.min.js lib/jquery.ba-bbq.min.js lib/handlebars-1.0.0.js lib/underscore-min.js )

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

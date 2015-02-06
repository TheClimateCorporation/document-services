require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"
require 'lograge'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Kernel.silence_warnings do
  Bundler.require(*Rails.groups)
end

module Sojourner
  # dearest alex, dearest stash,
  # please trigger a build.
  # love, cla

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.after_initialize do |app|
      app.routes.prepend do
        mount OkComputer::Engine => 'healthz'
      end
    end

    config.autoload_paths += %W(#{config.root}/lib/ #{config.root}/app/validators/ #{config.root}/app/middleware)

    config.lograge.enabled = true
    config.lograge.ignore_actions = ['ok_computer#index']
    config.lograge.custom_options = lambda do |event|
      {
        request_id: event.payload[:request_id],
        host: event.payload[:host],
        time: event.time
      }
    end

    DOT_PROPERTIES_PATH = "../doc-services.properties" #CHANGE-ME
    if File.exist?(DOT_PROPERTIES_PATH)
      DotProperties.load(DOT_PROPERTIES_PATH)
    else
      raise "You are missing an env.properties file"
    end

    # Custom Rack middleware
    config.middleware.insert_before "ActionDispatch::RequestId", "HttpRequestIdHandler"
  end
end

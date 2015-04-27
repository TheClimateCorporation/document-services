# The Climate Corporation licenses this file to you under under the Apache
# License, Version 2.0 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# See the NOTICE file distributed with this work for additional information
# regarding copyright ownership.  Unless required by applicable law or agreed
# to in writing, software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied.  See the License for the specific language governing permissions
# and limitations under the License.
require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Simone
  class Application < Rails::Application
    config.after_initialize do |app|
      app.routes.prepend do
        mount OkComputer::Engine => 'healthz'
      end
    end

    config.autoload_paths += %W(#{config.root}/lib/)

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

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end

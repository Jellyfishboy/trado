require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(:default, Rails.env)
end

module Trado
  class Application < Rails::Application

    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths << Rails.root.join('lib')

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    config.assets.expire_after 2.weeks

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    config.autoload_paths << Rails.root.join('lib')

    config.active_record.raise_in_transactional_callbacks = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Stops connecting to database while precompiling assets on deployment with capistrano
    config.assets.initialize_on_precompile = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Custom error pages
    config.exceptions_app = self.routes

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.generators do |g|
        g.test_framework :rspec,
            fixtures: true,
            view_specs: false,
            helper_specs: true,
            routing_specs: false,
            controller_specs: true,
            feature_specs: true
        g.fixture_replacement :factory_girl, dir: "spec/factories"
    end
  end
end

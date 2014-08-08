Trado::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded o
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Eager load code on boot.
  config.eager_load = false

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  
  config.action_mailer.preview_path = "#{Rails.root}/app/mailers/previews"

  # Set default URL
  config.action_mailer.default_url_options = { :host => Settings.mailer.development.host }

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Emails are appended to an array, non are sent outside the application
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    :address              => Settings.mailer.development.server,
    :port                 => Settings.mailer.development.port,
    :domain               => Settings.mailer.development.domain,
    :authentication       => "plain",
    :user_name            => Settings.mailer.development.user_name,
    :password             => Settings.mailer.development.password,
    :enable_starttls_auto => true

  }
  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Expands the lines which load the assets
  config.assets.debug = true

  # PayPal settings
  config.after_initialize do
    Rails.application.routes.default_url_options[:host] = Settings.mailer.development.host
    ActiveMerchant::Billing::Base.mode = :test
    paypal_options = {
      login: Settings.paypal.development.login,
      password: Settings.paypal.development.password,
      signature: Settings.paypal.development.signature
    }
    ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
  end
end

Trado::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files = false

  # Compress JavaScripts and CSS
  config.assets.js_compressor = :uglifier

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' 

  # Logs more concise errors
  config.lograge.enabled = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  config.action_controller.asset_host = Rails.application.secrets.aws_cloudfront_host_app

  config.assets.prefix = Rails.application.secrets.aws_cloudfront_prefix

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Set default URL
  config.action_mailer.default_url_options = { :host => Rails.application.secrets.global_host }

  config.action_controller.asset_host = Rails.application.secrets.global_host
  config.action_mailer.asset_host = Rails.application.secrets.global_host

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Emails are appended to an array, non are sent outside the application
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    :address              => Rails.application.secrets.mailer_server,
    :port                 => Rails.application.secrets.mailer_port,
    :domain               => Rails.application.secrets.mailer_domain,
    :authentication       => "plain",
    :user_name            => Rails.application.secrets.mailer_user_name,
    :password             => Rails.application.secrets.mailer_password,
    :enable_starttls_auto => true
  }
  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
end

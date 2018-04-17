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
	config.cache_store = :dalli_store,
						(ENV["MEMCACHIER_SERVERS"] || "").split(","),
	                    {:username => ENV["MEMCACHIER_USERNAME"],
	                     :password => ENV["MEMCACHIER_PASSWORD"],
	                     :failover => true,
	                     :socket_timeout => 1.5,
	                     :socket_failure_delay => 0.2,
	                     :down_retry_delay => 60
	                    }

	# Enable serving of images, stylesheets, and JavaScripts from an asset server
	# config.action_controller.asset_host = "http://assets.example.com"

	config.action_mailer.asset_host = "#{ENV['HEROKU_APP_NAME']}.herokuapp.com"
	config.action_controller.asset_host = "#{ENV['HEROKU_APP_NAME']}.herokuapp.com"

	config.assets.prefix = '/assets'

	config.serve_static_files = true

	# Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
	# config.assets.precompile += %w( search.js )

	# Disable delivery errors, bad email addresses will be ignored
	# config.action_mailer.raise_delivery_errors = false

	# Enable threaded mode
	# config.threadsafe!

	# Set default URL
	config.action_mailer.default_url_options = { :host => "#{ENV['HEROKU_APP_NAME']}.herokuapp.com" }

	# Don't care if the mailer can't send
	config.action_mailer.raise_delivery_errors = true

	# Emails are appended to an array, non are sent outside the application
	config.action_mailer.delivery_method = :smtp

	config.action_mailer.smtp_settings = {
		:address              => 'smtp.sendgrid.net',
		:port                 => 587,
		:authentication       => "plain",
		:user_name            => ENV['SENDGRID_USERNAME'],
		:password             => ENV['SENDGRID_PASSWORD'],
		:enable_starttls_auto => true,
		:domain               => ENV['MAILER_DOMAIN']
	}

	# Send deprecation notices to registered listeners
	config.active_support.deprecation = :notify
end
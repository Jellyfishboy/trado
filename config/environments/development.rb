Trado::Application.configure do
	# Settings specified here will take precedence over those in config/application.rb

	# In the development environment your application's code is reloaded o
	# every request. This slows down response time but is perfect for development
	# since you don't have to restart the web server when you make code changes.
	config.cache_classes = false
	# false value causes following exception: 'A XX been removed from the module tree but is still active!'

  	# Eager load code on boot.
  	config.eager_load = false

	# Raise an error on page load if there are pending migrations
	config.active_record.migration_error = :page_load

	# Show full error reports and disable caching
	config.consider_all_requests_local       = true
	config.action_controller.perform_caching = false
	  
	config.action_mailer.preview_path = "#{Rails.root}/app/mailers/previews"

	# Set default URL
	config.action_mailer.default_url_options = { :host => Rails.application.secrets.global_host }

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
	# Print deprecation notices to the Rails logger
	config.active_support.deprecation = :log

	# Expands the lines which load the assets
	config.assets.debug = true

	config.action_controller.asset_host = Rails.application.secrets.global_host
	config.action_mailer.asset_host = Rails.application.secrets.global_host
end

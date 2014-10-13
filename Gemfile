source 'http://rubygems.org'

gem 'rails', '4.1.0'

gem 'pg'

# Production gems
group :production do
  gem 'lograge'
end

# Development gems
group :development do
    gem 'better_errors'
    gem 'binding_of_caller'
    gem 'meta_request'
    gem 'quiet_assets'
    gem 'spring'
    # gem 'rack-mini-profiler'
    gem 'capistrano', '~> 2.15'
    gem 'bullet'
    gem 'metric_fu'
    gem 'capistrano-unicorn', :require => false, :platforms => :ruby
    gem 'thin'
    gem 'colorize'
end

group :test do
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'faker'
  # gem 'spork'
  # gem 'guard-rspec', :require => false
  # gem 'guard-spork'
  # gem 'email_spec'
end

group :development, :test do
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry-byebug'
  # gem 'terminal-notifier-guard', :platforms => :ruby
end

# Assets
gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'compass-rails'
gem 'haml'
gem 'haml-rails'
gem 'jquery-rails'
gem 'uglifier', '>= 1.0.3'
gem 'asset_sync'

# Web server
gem 'unicorn', :platforms => :ruby

# AJAX file upload
gem 'remotipart', '~> 1.2'
################
# Fix for upload bug for Carrierwave and Rails 4.1
################
gem 'activesupport-json_encoder'

# Logging/Monitoring
gem 'rollbar'
gem 'newrelic_rpm'

# Misc
gem 'global'
gem 'wicked'
gem 'protected_attributes'
gem 'tzinfo-data'
gem 'active_presenter'

# Pagination
gem 'kaminari'

# RTE
gem 'redactor-rails'

# Transaction handler
gem 'activemerchant'

# Authenication
gem 'devise'
gem 'cancan'

# Friendly URLs
gem 'friendly_id'

# Image uploader
gem 'mini_magick'
gem 'carrierwave'
gem 'fog'
gem 'unf' # Dependency for fog

# Sitemap
gem 'sitemap_generator'

# Background processing
gem 'whenever', '>= 0.8.4', :require => false

# JS Variables
gem 'gon'

# Performance
gem 'fast_blank'
gem 'jquery-turbolinks'
gem 'turbolinks'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'
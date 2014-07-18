source 'http://rubygems.org'

gem 'rails', '4.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Production gems
group :production do
  gem 'mysql2', :platforms => :ruby
  gem 'lograge'
end

# Development gems
group :development do
    gem 'better_errors'
    gem 'binding_of_caller'
    gem 'meta_request'
    gem 'quiet_assets'
    # gem 'rack-mini-profiler'
    gem 'capistrano', '~> 2.15'
    gem 'bullet'
    gem 'metric_fu'
    gem 'capistrano-unicorn', :require => false, :platforms => :ruby
end

group :test do
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'factory_girl_rails'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'faker'
  # gem 'spork'
  # gem 'guard-rspec', :require => false
  # gem 'guard-spork'
  # Testing postgresql on Travis CI
  gem 'pg'
  # gem 'email_spec'
end
gem 'capybara'
gem 'capybara-screenshot'

group :development, :test do
  gem 'pry'
  gem 'sqlite3'
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

# Logging/Monitoring
gem 'rollbar'
gem 'newrelic_rpm'

# Search
gem 'searchkick'

# Misc
gem 'global'
gem 'wicked'
gem 'foreman',   '~> 0.61.0'
gem 'protected_attributes'

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

# Email preview
gem 'rails_email_preview', '~> 0.2.19'

# Sitemap
gem 'sitemap_generator'

# Processing
gem 'whenever', :require => false

# JS Variables
gem 'gon'

# Performance
gem 'fast_blank'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'
source 'https://rubygems.org'

gem 'rails', '4.2.0'

gem 'pg'

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
    gem 'thin'
    gem 'colorize'
    gem 'capistrano-sidekiq'
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
  gem 'email_spec'
end

group :development, :test do
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry-byebug'
  gem 'mysql2'
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
gem 'sprockets', '2.11.0'

# AJAX file upload
gem 'remotipart', '~> 1.2'
################
# Fix for upload bug for Carrierwave and Rails 4.1
################
gem 'activesupport-json_encoder'

# Background processing
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sinatra', :require => nil

# Misc
gem 'global'
gem 'protected_attributes'
gem 'tzinfo-data'
gem 'active_presenter'
gem "auto_strip_attributes", "~> 2.0"

# Pagination
gem 'kaminari'

# RTE
gem 'redactor-rails'

# Transaction handler
gem 'activemerchant'
gem 'offsite_payments'

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

# GA
gem 'google-api-client'

# Performance
gem 'fast_blank'
gem 'jquery-turbolinks'
gem 'turbolinks'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'
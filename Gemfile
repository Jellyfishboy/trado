source 'https://rubygems.org'

gem 'rails', '4.2.6'

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
    gem 'capistrano-sidekiq'
end

group :test do
  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'aws-sdk' # upload capybara screenshot fails
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'shoulda-matchers', '2.8.0'
  gem 'email_spec'
  gem 'fuubar'
  gem 'test_after_commit'
  gem 'timecop'
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
gem 'protected_attributes'
gem 'tzinfo-data'
gem 'active_presenter'
gem "auto_strip_attributes", "~> 2.0"

# Pagination
gem 'kaminari'

# RTE
gem 'redactor-rails'

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

# Test coverage by Codacy
gem 'codacy-coverage', :require => false

# Colour console
gem 'colorize'

# documentation
gem 'annotate'

# fake data
gem 'faker'

# Caching
gem 'dalli'

# Browser detection
gem 'browser'

gem 'trado_pdf_invoice_module', path: '/Users/tomdallimore/Projects/Modules/trado-pdf-invoice-module'
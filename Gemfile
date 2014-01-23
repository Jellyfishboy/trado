source 'http://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Production gems
group :production do
  gem 'mysql2'
  gem 'lograge'
end

# Development gems
group :development do
    gem 'better_errors'
    gem 'binding_of_caller'
    gem 'meta_request'
    gem 'haml-rails'
    gem 'quiet_assets'
    gem 'rack-mini-profiler'
    gem 'capistrano', '~> 2.15'
    gem 'bullet'
    gem 'haml'
    gem 'rails_best_practices'
    platforms :ruby do
      gem 'capistrano-unicorn', :require => false
    end
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  # gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'faker'
end

group :development, :test do
  gem 'pry'
  gem 'sqlite3'
end
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  gem 'jquery-rails'
  gem 'uglifier', '>= 1.0.3'
  gem 'asset_sync'
end

platforms :ruby do
  gem 'unicorn'
end

# Logging/Monitoring
gem 'rollbar'
gem 'newrelic_rpm'

# Datepicker
gem 'bootstrap-datepicker-rails'

gem 'wicked'

gem 'foreman',   '~> 0.61.0'

# RTE
gem 'redactor-rails'

# Transaction handler
gem 'activemerchant'

# Authenication
gem 'devise'
gem 'cancan'

# Friendly URLs
gem 'friendly_id', '~> 4.0.10'

# Image uploader
gem 'mini_magick'
gem 'carrierwave'
gem 'fog'
gem 'unf' # Dependency for fog

# Search indexing
gem 'sunspot_rails'
gem 'sunspot_solr'

# Administration
gem 'rails_admin'

# Sitemap
gem 'sitemap_generator'

# Global
gem 'global'

# Processing
gem 'sidekiq', :require => false
gem 'sidekiq-failures'
gem 'slim'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'whenever', :require => false

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', git: 'https://github.com/codahale/bcrypt-ruby.git', :require => 'bcrypt'
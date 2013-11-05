source 'http://rubygems.org'

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Database
gem 'mysql2'

# HTML Framework
gem 'haml'

# Production gems
group :production do
  gem 'unicorn'
  gem 'therubyracer'
end

# Development gems
group :development do
    gem 'better_errors'
    gem 'binding_of_caller'
    gem 'meta_request'
    gem 'haml-rails'
    gem 'capistrano'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'jquery-rails'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

# Authenication
gem 'devise'
gem 'cancan'

# Image uploader
gem 'mini_magick', '~> 3.5.0'
gem 'carrierwave'

# Debugging
gem 'pry'

# Administration
gem 'rails_admin'

# Processing
gem 'sidekiq', :require => false
gem 'sidekiq-failures'
gem 'slim'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'whenever', :require => false

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', git: 'https://github.com/codahale/bcrypt-ruby.git', :require => 'bcrypt'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

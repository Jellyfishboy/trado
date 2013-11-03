set :application, 'gimson_robotics'
set :user, 'root'
set :scm, 'git'
set :repository, 'git@github.com:Jellyfishboy/gimson_robotics.git'
set :scm_verbose, true
set :domain, '146.185.130.90'
set :deploy_to, '/var/www/gimsonrobotics/'
set :branch, 'master'

server domain, :app, :web, :db, :primary => true

# Bundler for remote gem installs
require "bundler/capistrano"

# Only keep the latest 3 releases
set :keep_releases, 3
after "deploy:restart", "deploy:cleanup"

# deploy config
set :deploy_via, :remote_cache
set :copy_exclude, [".git", ".DS_Store", ".gitignore", ".gitmodules"]
set :use_sudo, false

desc "Setup database"
task :setup_database, :roles => :app do
	run "cd /var/www/gimsonrobotics/current && RAILS_ENV=production rake db:create db:schema:load"
end

# additional settings
default_run_options[:pty] = true
default_run_options[:shell] = '/bin/bash --login'

after :deploy, 'setup_database'
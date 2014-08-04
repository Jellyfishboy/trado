set :application, 'gimson_robotics'
set :user, 'root'
set :scm, 'git'
set :repository, 'git@github.com:Jellyfishboy/trado.git'
set :scm_verbose, true
set :domain, '37.139.0.243'
set :deploy_to, '/home/gimsonrobotics/'
set :branch, 'master'

server domain, :app, :web, :db, :primary => true

require 'capistrano-unicorn'

# Bundler for remote gem installs
require "bundler/capistrano"

# Only keep the latest 3 releases
set :keep_releases, 3
after "deploy:restart", "deploy:cleanup"

set :normalize_asset_timestamps, false

# deploy config
set :deploy_via, :remote_cache
set :copy_exclude, [".git", ".DS_Store", ".gitignore", ".gitmodules"]
set :use_sudo, false

# For RBENV
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

namespace :configure do
  desc "Setup application configuration"
  task :application, :roles => :app do
      run "yes | cp /home/configs/settings.yml /home/gimsonrobotics/current/config"
  end
  desc "Setup database configuration"
  task :database, :roles => :app do
    run "yes | cp /home/configs/database.yml /home/gimsonrobotics/current/config"
  end
  desc "Update crontab configuration"
  task :crontab, :roles => :app do
    run "cd /home/gimsonrobotics/current && whenever --update-crontab gimson_robotics"
  end
end
namespace :database do
  desc "Migrate the database"
  task :migrate, :roles => :app do
    run "cd /home/gimsonrobotics/current && RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
  end
end
namespace :assets do
    desc "Install Bower dependencies"
    task :bower, :roles => :app do
      run "cd /home/gimsonrobotics/current && sudo bower install --allow-root"
    end 
    desc "Compile assets"
    task :compile, :roles => :app do
        run "cd /home/gimsonrobotics/current && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
    end
    desc "Generate sitemap"
    task :refresh_sitemaps do
      run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake sitemap:refresh"
    end
end
namespace :rollbar do
  desc "Notify Rollbar of deployment"
  task :notify, :roles => :app do
    set :revision, `git log -n 1 --pretty=format:"%H"`
    set :local_user, `whoami`
    set :rollbar_token, ENV['ROLLBAR_ACCESS_TOKEN']
    rails_env = fetch(:rails_env, 'production')
    run "curl https://api.rollbar.com/api/1/deploy/ -F access_token=#{rollbar_token} -F environment=#{rails_env} -F revision=#{revision} -F local_username=#{local_user} >/dev/null 2>&1", :once => true
  end
end

# additional settings
default_run_options[:pty] = true

after :deploy, 'configure:application'
after 'configure:application', 'configure:database'
after 'configure:database', 'configure:crontab'
after 'configure:crontab', 'database:migrate'
after 'database:migrate', 'assets:bower'
after 'assets:bower', 'assets:compile'
after 'assets:compile', 'assets:refresh_sitemaps'
after 'assets:refresh_sitemaps', 'rollbar:notify'
after 'rollbar:notify', 'unicorn:restart'

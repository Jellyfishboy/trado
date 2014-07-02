namespace :trado do
  desc "Install Trado for the first time"
  task :install => :environment do
    `bundle exec rake db:reset`
  end
end

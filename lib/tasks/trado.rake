namespace :trado do
  desc "Install Trado for the first time"
  task :install => :environment do
    `bundle exec rake db:drop`
    `bundle exec rake db:create`
    `bundle exec rake db:migrate`
    `bundle exec rake db:seed`
  end
end

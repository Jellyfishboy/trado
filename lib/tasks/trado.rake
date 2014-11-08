namespace :trado do
    task :install => :environment do
        Rails.logger.info 'Trado -> Installing Trado for the first time...'.colorize(:cyan)
        Rails.logger.info 'Dropping the database'.colorize(:green)
        Rake::Task['db:drop'].invoke     
        Rails.logger.info 'Creating the database'.colorize(:green)
        Rake::Task['db:create'].invoke
        Rails.logger.info 'Loading the new schema'.colorize(:green)
        Rake::Task['db:schema:load'].invoke
        Rails.logger.info 'Seeding the database'.colorize(:green)
        `bundle exec rake db:seed SEED_TYPE=install --trace`
        Rails.logger.info 'Trado -> Finished installation - you can now spin up the application server'.colorize(:cyan)
    end

    task :demo => :environment do

    end
end

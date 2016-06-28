namespace :trado do
    task install: :environment do
        puts 'Trado -> Installing Trado for the first time...'.colorize(:cyan)
        puts 'Dropping the database'.colorize(:green)
        Rake::Task['db:drop'].invoke     
        puts 'Creating the database'.colorize(:green)
        Rake::Task['db:create'].invoke
        puts 'Loading the new schema'.colorize(:green)
        Rake::Task['db:schema:load'].invoke
        puts 'Seeding the database'.colorize(:green)
        `bundle exec rake db:seed --trace`
        puts 'Trado -> Finished installation - you can now spin up the application server'.colorize(:cyan)
    end

    task demo: :environment do
        puts 'Trado -> Demo application setup...'.colorize(:cyan)
        puts 'Dropping the database'.colorize(:green)
        Rake::Task['db:drop'].invoke     
        puts 'Creating the database'.colorize(:green)
        Rake::Task['db:create'].invoke
        puts 'Loading the new schema'.colorize(:green)
        Rake::Task['db:schema:load'].invoke
        puts 'Seeding the database'.colorize(:green)
        `bundle exec rake db:seed SEED_TYPE=demo --trace`
        puts 'Trado -> Finished demo setup'.colorize(:cyan)
    end
end

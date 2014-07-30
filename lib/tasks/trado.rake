require 'highline/import'

    namespace :trado do
    desc "Install Trado for the first time"
    task :install => :environment do
        puts 'Trado -> Installing Trado for the first time...'.colorize(:cyan)
        Rake::Task['db:drop'].invoke if agree('Do you want to drop the database? (yes or no)'.colorize(:red))    
        puts 'Creating the databases'.colorize(:green)
        Rake::Task['db:create'].invoke
        puts 'Loading the new schema'.colorize(:green)
        Rake::Task['db:schema:load'].invoke
        puts 'Seeding the database'.colorize(:green)
        'bundle exec db:seed seed_type=install'
    end

    task :demo => :environment do

    end
end

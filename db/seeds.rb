# Reset seed on id field - only works with postgresql
ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }

puts "-----------------------------"

puts "Loading install seeds: \n /seeds/install_seeds.rb".colorize(:cyan)
require File.dirname(__FILE__) + '/seeds/install_seeds'

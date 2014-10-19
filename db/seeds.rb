
ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.reset_pk_sequence!(t) }

TYPE = ENV['SEED_TYPE']
puts "-----------------------------"

if TYPE == 'install'
    seed_file = File.dirname(__FILE__) + '/seeds/install_seeds'
    Rails.logger.info "Loading install seeds: \n #{seed_file}".colorize(:cyan)
elsif TYPE == 'demo'
    seed_file = File.dirname(__FILE__) + '/seeds/demo_seeds'
    Rails.logger.info "Loading demo seeds: \n #{seed_file}".colorize(:cyan)
end

require seed_file

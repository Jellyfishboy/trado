puts "-----------------------------"
Rails.logger.info "Starting install seeds:".colorize(:cyan)

require File.dirname(__FILE__) +  '/install/admin_seeds'
require File.dirname(__FILE__) +  '/install/page_seeds'
require File.dirname(__FILE__) +  '/install/country_seeds'
require File.dirname(__FILE__) +  '/install/product_seeds'
require File.dirname(__FILE__) +  '/install/delivery_service_seeds'

puts "-----------------------------"
Rails.logger.info "Finished install seeds".colorize(:cyan)
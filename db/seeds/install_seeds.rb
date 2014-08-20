puts "-----------------------------"
puts "Starting install seeds:".colorize(:cyan)

require File.dirname(__FILE__) +  '/install/admin_seeds'
require File.dirname(__FILE__) +  '/install/product_seeds'
require File.dirname(__FILE__) +  '/install/delivery_service_seeds'

puts "-----------------------------"
puts "Finished install seeds".colorize(:cyan)
puts "-----------------------------"
puts "Executing install seeds:".colorize(:green)

require File.dirname(__FILE__) +  '/install/admin_seeds'
require File.dirname(__FILE__) +  '/install/product_seeds'
require File.dirname(__FILE__) +  '/install/delivery_seeds'

puts "-----------------------------"
puts "Finished install seeds".colorize(:cyan)
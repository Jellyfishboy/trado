puts "-----------------------------"
puts "Executing install seeds:".colorize(:green)

require File.dirname(__FILE__) +  '/install/admin_seeds'
require File.dirname(__FILE__) +  '/install/product_seeds'
require File.dirname(__FILE__) +  '/install/shipping_seeds'

puts "-----------------------------"
puts "Finished install seeds".colorize(:cyan)
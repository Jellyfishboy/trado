puts "-----------------------------"
puts "Starting demo seeds:".colorize(:cyan)

# require File.dirname(__FILE__) +  '/demo/admin_seeds'
# require File.dirname(__FILE__) +  '/demo/page_seeds'
# require File.dirname(__FILE__) +  '/demo/country_seeds'
require File.dirname(__FILE__) +  '/demo/category_seeds'
require File.dirname(__FILE__) +  '/demo/variant_type_seeds'
require File.dirname(__FILE__) +  '/demo/product_seeds'
# require File.dirname(__FILE__) +  '/demo/accessory_seeds'
# require File.dirname(__FILE__) +  '/demo/delivery_service_seeds'

puts "-----------------------------"
puts "Finished demo seeds".colorize(:cyan)
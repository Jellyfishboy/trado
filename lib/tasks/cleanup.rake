namespace :cleanup do
  desc "removes stale and inactive orders from the database"
  task :orders => :environment do
    # Find all the orders older than yesterday, that are not active yet
    stale_orders = Order.where("DATE(created_at) < DATE(?)", Date.yesterday).where("status is not 'active'")
    # delete the addresses
    stale_orders.each do |order|
        order.ship_address.destroy
        order.bill_address.destroy
    end
    # delete the orders
    stale_orders.map(&:destroy)
  end
end
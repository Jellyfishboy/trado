namespace :cleanup do
  desc "removes stale and inactive orders from the database"
  task :orders => :environment do
    # Find all the orders older than yesterday, that are not active yet
    stale_orders = Order.where("DATE(created_at) < DATE(?)", Date.yesterday).where("status is not 'active'")
    # delete the orders
    stale_orders.map(&:destroy)
  end
end
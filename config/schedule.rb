# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, "/var/log/gimson_robotics/schedule.log"

every 1.day, :at => '4:00am' do
    runner 'Order.clear_orders'
end
every 1.day, :at => '4:10am' do
    runner "Cart.clear_carts"
end

every 1.day, :at => '5:00 am' do
  rake "-s sitemap:refresh"
end

every 1.day, :at => '7:00 am' do
    runner "Mailatron4000::Orders.dispatch_all"
end

every 1.day, :at => '8:30 am' do
    runner "Mailatron4000::Stock.warning"
end

every 1.day, :at => '9:00 am' do
    runner "Mailatron4000::Stock.notify"
end 


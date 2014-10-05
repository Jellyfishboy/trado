# Load the rails application
require File.expand_path('../application', __FILE__)


# Initialize the rails application
Trado::Application.initialize!

# begin
#     ActiveRecord::Base.connection
# rescue ActiveRecord::NoDatabaseError
#     puts 'No database exists for your application.'.colorize(:red)
#     puts 'Run \'rake trado:install\' command to get started with some sample data.'.colorize(:cyan)
#     exit
# end

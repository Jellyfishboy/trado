# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Trado::Application.initialize!
require_dependency 'mail_daemon'
require_dependency 'payatron_4000'
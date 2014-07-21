# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Trado::Application.initialize!
require_dependency 'shipatron_4000'
require_dependency 'mailatron_4000'
require_dependency 'payatron_4000'
require_dependency 'deep_struct'
require_dependency 'store'
require_dependency 'renderer'


# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Test5::Application.initialize!
DateTime::DATE_FORMATS[:short]="%Y-%m-%d %H:%M:%S"
Time::DATE_FORMATS[:short] = "%Y-%m-%d %H:%M:%S"
Date::DATE_FORMATS[:short] = "%Y-%m-%d"

# if "irb" == $0
#   config.logger = Logger.new(Rails.root.join('path_to_log_file.txt'))
# end
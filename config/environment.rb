# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
DailyQuests::Application.initialize!

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'hero', 'heroes'
end

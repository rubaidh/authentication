# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'
  config.action_controller.session = { :key => "_authentication_session", :secret => "OhRu4ooheingai3yau1zahM7Doo6ah" }
  config.gem 'state_machine'
  config.gem 'object_daddy'
end

require File.join(File.dirname(__FILE__), '..', 'init')

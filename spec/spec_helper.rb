# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'


def test_login_as(role = nil)
  login = generate_user.login
  if role.is_a?(Symbol)
    login = generate_user(role => true).login
  end

  controller.send :current_login=, login
end
alias :login :test_login_as

def generate_user(stubs = {})
  user = User.spawn(stubs) do |user|
    user.login = Login.spawn(:user => user)
  end
  user.save!
  user
end

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end

ActiveRecord::Migrator.migrate(File.join(File.dirname(__FILE__), "..", "generators", "authentication_migrations", "templates", "migrations"))

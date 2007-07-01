# Required gem libraries
require 'md5'
require 'bcrypt'

# Register with ActionController and ActiveRecord.
ActionController::Base.send(:extend, Rubaidh::Authentication::Controller::ActMethods)
ActiveRecord::Base.send(    :extend, Rubaidh::Authentication::UserModel::ActMethods)
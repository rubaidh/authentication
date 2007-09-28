# Required gem libraries
require 'md5'
require 'bcrypt'
require 'rubaidh/authentication'

# Register with ActionController and ActiveRecord.
ActionController::Base.send(:extend, Rubaidh::Authentication::Controller::ActMethods)
ActionController::Base.send(:extend, Rubaidh::Authentication::SessionController::ActMethods)
ActiveRecord::Base.send(    :extend, Rubaidh::Authentication::UserModel::ActMethods)
ActiveRecord::Base.send(    :extend, Rubaidh::Authentication::RoleModel::ActMethods)
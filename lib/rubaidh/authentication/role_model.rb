module Rubaidh
  module Authentication
    module RoleModel
      module ActMethods
        def rubaidh_authentication_role(options = {})
          options[:user_model] ||= :users
          options[:user_model] = options[:user_model].to_sym

          class_inheritable_accessor :rubaidh_authentication_role_options
          self.rubaidh_authentication_role_options = options

          Rubaidh::Authentication.roles.each do |role|
            cattr_accessor role
            class_variable_set("@@#{role}", find_or_create_by_name(role.to_s))
          end

          has_and_belongs_to_many rubaidh_authentication_role_options[:user_model], :uniq => true
          validates_uniqueness_of :name
        end
      end
    end
  end
end
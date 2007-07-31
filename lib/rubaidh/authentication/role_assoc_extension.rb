module Rubaidh
  module Authentication
    # FIXME: This relies on the role having the class name 'Role'.  I'm sure
    # I should be able to figure it out from the association extension, but
    # that'll do for now.
    module RoleAssocExtension
      Rubaidh::Authentication.roles.each do |role|
        if role == Rubaidh::Authentication.god_role
          class_eval <<-CODE
            def #{role}?
              @is_#{role} ||= self.include?(Role.#{role})
            end
          CODE
        else
          class_eval <<-CODE
            def #{role}?
              @is_#{role} ||= #{Rubaidh::Authentication.god_role}? || self.include?(Role.#{role})
            end
          CODE
        end
        class_eval <<-CODE
          def add_#{role}
            self << Role.#{role} unless #{role}?
          end

          def del_#{role}
            self.delete Role.#{role}
          end
        CODE
      end
    end
  end
end
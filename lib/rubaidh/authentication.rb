module Rubaidh
  module Authentication
    mattr_accessor :god_role
    @@god_role = :administrator

    mattr_accessor :roles
    @@roles = [ god_role ]
  end
end
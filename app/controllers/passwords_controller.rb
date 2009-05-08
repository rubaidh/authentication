# Passwords Controller
#
# Created on April 29, 2009 14:30 by Mark Connell as part
# of the "Login app" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

class PasswordsController < AuthenticatableController
  include Rubaidh::Authentication::PasswordsControllerMixin
end

# Authenticatable Controller
#
# Created on April 21, 2009 11:26 by Mark Connell as part
# of the "Login app" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

# A base controller for the application which enables authentication.  Any
# controllers which inherit from this one will have the ability to require a
# user to login.  In fact, the default behaviour is to require the user to log
# in to any controller inherited from this one, which can be overridden with
# +login_not_required+.
class AuthenticatableController < ApplicationController
  include Rubaidh::Authentication::AuthenticatableControllerMixin
end

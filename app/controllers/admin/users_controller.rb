# Admin::Users Controller
#
# Created on May 01, 2009 13:46 by Mark Connell as part
# of the "Login app" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

class Admin::UsersController < AdminController
  include Rubaidh::Authentication::Admin::UsersControllerMixin
end

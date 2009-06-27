# Admin Controller
#
# Created on April 30, 2009 15:41 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

class AdminController < AuthenticatableController
  include Rubaidh::Authentication::Controllers::AdminControllerMixin
end

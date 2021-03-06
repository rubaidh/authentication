# Sessions Controller
#
# Created on April 21, 2009 10:38 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

class SessionsController < AuthenticatableController
  include Rubaidh::Authentication::Controllers::SessionsControllerMixin
end

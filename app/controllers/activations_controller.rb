# Activations Controller
#
# Created on April 30, 2009 10:37 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

class ActivationsController < AuthenticatableController
  include Rubaidh::Authentication::ActivationsControllerMixin
end

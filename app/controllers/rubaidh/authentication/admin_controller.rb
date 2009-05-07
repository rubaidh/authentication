# Admin Controller
#
# Created on April 30, 2009 15:41 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++
module Rubaidh
  module Authentication
    class AdminController < Rubaidh::Authentication::AuthenticatableController

      # Specify that login is required in order to successfully access some or all
      # of the actions on this controller.  Options:
      #
      # * :for - a list of actions for which login is required.  By default, this
      #   will be *all* actions.
      def self.administrator_login_required(options = {})
        if only = options.delete(:for)
          before_filter :administrator_login_required, :only => only
        else
          before_filter :administrator_login_required
        end
      end

      # Specify that login is *not* required in order to successfully access some
      # or all of the actions on this controller.  Options:
      #
      # * :for - a list of actions for which login is *not* required.  By default,
      #   this will be *all* actions.
      def self.administrator_login_not_required(options = {})
        if only = options.delete(:for)
          skip_before_filter :administrator_login_required, :only => only
        else
          skip_before_filter :administrator_login_required
        end
      end

      # flip on admin login requirement for all controllers that inherit
      administrator_login_required

      protected

      def administrator_login_required
        (logged_in? && current_login.user.administrator?) || admin_access_denied
      end

      def admin_access_denied
        raise ActionController::Forbidden
      end

    end
  end
end

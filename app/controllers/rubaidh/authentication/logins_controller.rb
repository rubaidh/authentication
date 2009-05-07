# Logins Controller
#
# Created on April 21, 2009 18:13 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++
module Rubaidh
  module Authentication
    class LoginsController < Rubaidh::Authentication::AuthenticatableController
      login_not_required :for => [:activate]

      def activate
        @login = Login.find_by_activation_code(params[:activation_code])
        respond_to do |format|
          if @login.present? && @login.activate
            self.current_login = @login
            format.html do
              flash[:notice] = "Login account successfully activated, thank you"
              redirect_to(root_url)
            end
          else
            format.html do
              flash[:error] = "There was an error activating your account."
              redirect_to(new_session_url)
            end
          end
        end
      end

    end
  end
end

# Activations Controller
#
# Created on April 30, 2009 10:37 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++
module Rubaidh
  module Authentication
    class ActivationsController < Rubaidh::Authentication::AuthenticatableController
      login_not_required :for => [:new, :create]

      def new
        respond_to do |format|
          format.html # new.html
        end
      end

      def create
        @login = Login.find_by_email(params[:email])
        if @login.present? && @login.pending?
          @login.resend_activation!
          flash[:notice] = "Your activation email has been resent."
          redirect_to login_url
        else
          flash[:error] = "The email address you specified does not have a pending account associated with it."
          render :action => 'new'
        end
      end
    end
  end
end

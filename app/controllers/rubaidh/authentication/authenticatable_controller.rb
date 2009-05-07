# Authenticatable Controller
#
# Created on April 21, 2009 11:26 by Mark Connell as part
# of the "authentication" project.
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
module Rubaidh
  module Authentication
    class AuthenticatableController < ApplicationController
      before_filter :attempt_to_log_in

      # Specify that login is required in order to successfully access some or all
      # of the actions on this controller.  Options:
      #
      # * :for - a list of actions for which login is required.  By default, this
      #   will be *all* actions.
      def self.login_required(options = {})
        if only = options.delete(:for)
          before_filter :login_required, :only => only
        else
          before_filter :login_required
        end
      end

      # Specify that login is *not* required in order to successfully access some
      # or all of the actions on this controller.  Options:
      #
      # * :for - a list of actions for which login is *not* required.  By default,
      #   this will be *all* actions.
      def self.login_not_required(options = {})
        if only = options.delete(:for)
          skip_before_filter :login_required, :only => only
        else
          skip_before_filter :login_required
        end
      end

      # By default, a login is required for any controller inheriting from this
      # one.  This is a sensible default. :-)
      login_required

      protected

      def store_redirected_from_location
        session[:return_uri] = request.request_uri
      end

      def redirect_back_or_default
        redirect_to(session[:return_uri] || root_url)
      end

      # method to check the the object belongs to me (user or login)
      def i_am?(object)
        if (object.class == Login && current_login == object) || (object.class == User && current_login.user == object)
          true
        else
          false
        end
      end

      def logged_in?
        current_login.present?
      end
      helper_method :logged_in?

      def current_login
        @current_login
      end
      helper_method :current_login

      def access_denied
        store_redirected_from_location
        respond_to do |format|
          format.html do
            redirect_to login_url
          end
        end
      end

      def login_required
        logged_in? || access_denied
      end

      def current_login=(new_login)
        session[:login_id] = new_login.present? ? new_login.id : nil
        @current_login = new_login
      end

      def attempt_to_log_in
        self.current_login ||= login_from_session || login_from_cookie
      end

      def login_from_session
       Login.find_by_id(session[:login_id]) if session[:login_id].present?
      end

      def login_from_cookie
        Login.find_by_remember_token(remember_cookie) if remember_cookie.present?
      end

      def remember_cookie
        cookies[:auth_token]
      end

    end
  end
end

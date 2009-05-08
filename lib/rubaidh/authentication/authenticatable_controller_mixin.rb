module Rubaidh
  module Authentication
    module AuthenticatableControllerMixin

      def self.included(controller)
        # load in the instance methods
        controller.send(:include, InstanceMethods)

        # open up the class
        controller.class_eval do
          before_filter :attempt_to_log_in

          helper_method :logged_in?
          helper_method :current_login

          hide_action :current_login, :logged_in?

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
          login_required
        end
      end

      module InstanceMethods
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

        def current_login
          @current_login
        end

        def current_user
          current_login.user
        end

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
      end # of instance methods

    end
  end
end

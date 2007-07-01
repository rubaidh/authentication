module Rubaidh
  module Authentication
    module Controller
      module ActMethods
        def rubaidh_authentication(options = {})
          options[:authenticate_every_action] ||= true
        
          class_inheritable_accessor :acts_as_login_options
          self.acts_as_login_options = options

          # Only do these actions once.
          unless included_modules.include?(InstanceMethods)
            include InstanceMethods
            extend ClassMethods
            ApplicationHelper.send(:include, InstanceMethods)

            before_filter :authenticate_with_cookie
            before_filter :authenticate if acts_as_login_options[:authenticate_every_action]
          end
        end
      end

      module ClassMethods
        def login_not_required_for(*actions)
          if actions.length == 1 && actions[0].to_sym == :all
            skip_before_filter :authenticate
          else
            skip_before_filter :authenticate, :only => actions
          end
        end
      end

      module InstanceMethods
        # Is the current session already logged in?
        def session_authenticated?
          !current_user.blank?
        end

        def current_user
          # Use find_by_id rather than find because we want nil rather than an
          # exception if it doesn't work.
          @current_user ||= User.find_by_id(session[:user])
        end

        protected
        def current_user=(user)
          @current_user = user
          session[:user] = user.id unless user.blank?
        end

        def authenticate_with_cookie
          return unless cookies[:auth_token] && !session_authenticated?
          user = User.find_by_remember_token(cookies[:auth_token])
          if user && user.remember_token?
            user.remember_me_for 2.weeks
            self.current_user = user
            cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
            flash[:notice] = "Logged in successfully"
          end
        end

        # Authenticate the user using either the current session or HTTP basic auth,
        # depending upon the format the request comes in on.  If it's a regular
        # user and they're not logged in, redirect to a friendly login page.
        def authenticate
          case request.format
          when Mime::XML, Mime::ATOM
            if user = authenticate_with_http_basic { |u, p| User.find_by_email_address_and_password(u, p) }
              self.current_user = user
            else
              request_http_basic_authentication
            end
          else
            if !session_authenticated?
              redirect_to(new_session_path) and return false
            end
          end
        end
      end
    end
  end
end
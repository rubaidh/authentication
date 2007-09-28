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
            
            class << self
              Rubaidh::Authentication.roles.each do |role|
                class_eval <<-CODE
                  def #{role}_role_required_for(*actions)
                    if actions.length == 1 && actions[0].to_sym == :every_action
                      before_filter :authorise_current_user_as_#{role}
                    else
                      before_filter :authorise_current_user_as_#{role}, :only => actions
                    end
                  end
                CODE
              end
            end
            Rubaidh::Authentication.roles.each do |role|
              class_eval <<-CODE
                def authorise_current_user_as_#{role}
                  unless session_authenticated? && current_user.roles.#{role}?
                    flash[:error] = "Request operation requires #{role.to_s.humanize} role."
                    redirect_to(new_session_path) and return false
                  end
                end
              CODE
            end
            
            ApplicationHelper.send(:include, InstanceMethods)

            before_filter :authenticate_with_cookie
            before_filter :authenticate if acts_as_login_options[:authenticate_every_action]
          end
        end
      end

      module ClassMethods
        def login_not_required_for(*actions)
          if actions.length == 1 && actions[0].to_sym == :any_action
            skip_before_filter :authenticate
          else
            skip_before_filter :authenticate, :only => actions
          end
        end
        
        def login_required_for(*actions)
          if actions.length == 1 && actions[0].to_sym == :every_action
            before_filter :authenticate
          else
            before_filter :authenticate, :only => actions
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
            if user = authenticate_with_http_basic { |u, p| User.authenticate(u, p) }
              self.current_user = user
            else
              request_http_basic_authentication
            end
          else
            if !session_authenticated?
              remember_requested_location
              redirect_to(new_session_path) and return false
            end
          end
        end

        def remember_requested_location(location = request.request_uri)
          session[:requested_location] = location
        end

        def redirect_to_requested_location_or_default(default = root_path)
          location = session[:requested_location]
          session[:requested_location] = nil
          
          redirect_to(location ? location : default)
        end
      end
    end
  end
end
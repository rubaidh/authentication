module Rubaidh
  module Authentication
    module SessionController
      module ActMethods
        def rubaidh_authentication_session_controller
          include InstanceMethods unless included_modules.include?(InstanceMethods)
        end
      end

      module InstanceMethods
        private

        def login_and_redirect_to_requested_location_or_default(default_location)
          if using_open_id?
            open_id_authentication(default_location)
          elsif user = params[:user]
            password_authentication(user[:username], user[:password], default_location)
          end
        end

        def open_id_authentication(default_location)
          authenticate_with_open_id do |result, identity_url|
            if result.successful?
              if self.current_user = User.find_by_identity_url(identity_url)
                successful_login(default_location)
              else
                failed_login "Sorry, no user by that identity URL exists (#{identity_url})"
              end
            else
              failed_login result.message
            end
          end
        end
  
        def password_authentication(username, password, default_location)
          self.current_user = User.authenticate(username, password)
          if session_authenticated?
            successful_login(default_location)
          else
            failed_login "Your username or password was not recognised.  Please check it and try again."
          end
        end

        def successful_login(default_location)
          if params[:user] && params[:user][:remember_me] == "1"
            self.current_user.remember_me_for 2.weeks
            cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
          end
          redirect_to_requested_location_or_default(default_location)
          flash[:notice] = "Logged in successfully"
        end

        def failed_login(message)
          flash[:notice] = message
          new
          render :action => 'new'
        end

        def log_out_and_redirect_to(location)
          self.current_user.forget_me if session_authenticated?
          cookies.delete :auth_token
          reset_session
          flash[:notice] = "You have been logged out."
          redirect_to location
        end
      end
    end
  end
end
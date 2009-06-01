module Rubaidh
  module Authentication
    module SessionsControllerMixin

      def self.included(controller)
        # load the instance methods
        controller.send(:include, InstanceMethods)

        controller.class_eval do
          login_not_required :for => [ :new, :create, :destroy ]
        end
      end

      module InstanceMethods
        def new
          @page_title = "Login"
          store_location
          respond_to do |format|
            format.html # new.html.erb
          end
        end

        def create
          @user = User.authenticate(params[:email], params[:password])

          respond_to do |format|
            if @user.present?
              last_login = @user.last_logged_in_at
              login_as(@user, params[:remember_me])
              format.html do
                flash[:notice] = "Successfully logged in"
                flash[:notice] += ", last login at #{last_login}" if last_login.present?
                redirect_back_or_default
              end
            else
              format.html do
                flash[:error] = "Could not log in with that email and password combination"
                render :action => 'new'
              end
            end
          end
        end

        def destroy
          logout
          respond_to do |format|
            format.html { flash[:notice] = "Successfully logged out" }
          end
        end

        protected

         def login_as(user, remember_me = false)
           user.update_attribute(:last_logged_in_at, Time.now)
           self.current_user = user

           handle_remember_cookie(remember_me)
         end

         def handle_remember_cookie(remember_me = false)
           if current_user.present? && remember_me
             current_user.remember_me
             current_user.save
             set_remember_cookie
           else
             current_user.forget_me if current_user.present?
             clear_remember_cookie
           end
         end

         def set_remember_cookie
           cookies[:auth_token] = {
             :value => current_user.remember_token,
             :expires => current_user.remember_token_expires_at
           }
         end

         def clear_remember_cookie
           cookies.delete :auth_token
         end

         def logout
           @current_user.forget_me if @current_user.respond_to?(:forget_me)
           @current_user = nil

           #clear_remember_cookie
           clear_session_variables
         end

         def clear_session_variables
           [:user_id].each do |session_variable|
             session[session_variable] = nil
           end
         end

         # store the HTTP_REFERER if it exists and nil the redirect_back_uri so the user goes where intended
         def store_location
           if request.env['HTTP_REFERER'].present?
             session[:return_uri] = request.env['HTTP_REFERER']
           end
         end
      end
    end
  end
end

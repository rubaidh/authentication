# Sessions Controller
#
# Created on April 21, 2009 10:38 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

class SessionsController < AuthenticatableController
  login_not_required :for => [ :new, :create, :destroy ]

  def new
    store_location
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @login = Login.authenticate(params[:username], params[:password])

    respond_to do |format|
      if @login.present?
        last_login = @login.last_logged_in_at
        login_as(@login, params[:remember_me])
        format.html do
          flash[:notice] = "Successfully logged in"
          flash[:notice] += ", last login at #{last_login}" if last_login.present?
          redirect_back_or_default
        end
      else
        format.html do
          flash[:error] = "Could not log in with that username and password combination"
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

   def login_as(login, remember_me = false)
     login.update_attribute(:last_logged_in_at, Time.now)
     self.current_login = login

     handle_remember_cookie(remember_me)
   end

   def handle_remember_cookie(remember_me = false)
     if current_login.present? && remember_me
       current_login.remember_me
       current_login.save
       set_remember_cookie
     else
       current_login.forget_me if current_login.present?
       clear_remember_cookie
     end
   end

   def set_remember_cookie
     cookies[:auth_token] = {
       :value => current_login.remember_token,
       :expires => current_login.remember_token_expires_at
     }
   end

   def clear_remember_cookie
     cookies.delete :auth_token
   end

   def logout
     @current_login.forget_me if @current_login.respond_to?(:forget_me)
     @current_login = nil

     #clear_remember_cookie
     clear_session_variables
   end

   def clear_session_variables
     [:login_id].each do |session_variable|
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

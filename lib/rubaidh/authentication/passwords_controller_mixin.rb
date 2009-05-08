module Rubaidh
  module Authentication
    module PasswordsControllerMixin
      def self.included(controller)
        controller.send(:include, InstanceMethods)
        controller.class_eval do
          skip_before_filter :login_required, :only => [ :new, :create ]
        end
      end

      module InstanceMethods
        def new
          respond_to do |format|
            format.html # new.html
          end
        end

        def edit
          @login = current_login
        end

        def create
          @login = Login.find_by_email(params[:email])
          if @login.present?
            @login.reset_password!
            flash[:notice] = "A new password has been emailed to you."
            redirect_to login_url
          else
            flash[:error] = "We couldn't find a login with that email address."
            render :action => 'new'
          end
        end

        def update
          @login = current_login

          respond_to do |format|
            if @login.update_password(params[:password], params[:password_confirmation])
              flash[:notice] = 'Password was successfully updated.'
              format.html { redirect_to root_url }
            else
              format.html { render :action => "edit" }
            end
          end
        end
      end
    end
  end
end

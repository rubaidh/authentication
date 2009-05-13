module Rubaidh
  module Authentication
    module Admin
      module UsersControllerMixin
        def self.included(controller)
          controller.send(:include, InstanceMethods)
        end

        module InstanceMethods
          def index
            @users = User.active
            respond_to do |format|
              format.html # index.html.erb
            end
          end

          def inactive
            @users = User.inactive
            respond_to do |format|
              format.html # index.html.erb
            end
          end

          def show
            @user = User.find(params[:id])
            respond_to do |format|
              format.html # show.html.erb
            end
          end

          def edit
            @user = User.find(params[:id])
            respond_to do |format|
              format.html # edit.html.erb
            end
          end

          def update
            @user = User.find(params[:id])
            respond_to do |format|
              if @user.update_attributes(params[:user])
                flash[:notice] = "User successfully updated"
                format.html { redirect_to(admin_user_path(@user)) }
              else
                format.html { render :action => 'edit' }
              end
            end
          end

          def destroy
            @user = User.find(params[:id])
            unless i_am? @user
              @user.login.mark_deleted
              respond_to do |format|
                format.html do
                  flash[:notice] = "User successfully deleted"
                  redirect_to(admin_users_path)
                end
              end
            else
              respond_to do |format|
                format.html do
                  flash[:error] = "You cannot delete yourself."
                  redirect_to(admin_user_path(@user))
                end
              end
            end
          end

          def activate
            @user = User.find(params[:id])
            if @user.login.active?
              flash[:notice] = "User is already active"
            else
              @user.login.activate
              flash[:notice] = "User has been activated"
            end
            respond_to do |format|
              format.html { redirect_to(admin_user_path(@user)) }
            end
          end

          def suspend
            @user = User.find(params[:id])
            unless i_am? @user
              if @user.login.suspended?
                flash[:notice] = "User is already suspended"
              else
                @user.login.suspend
                flash[:notice] = "User has been suspended"
              end
              respond_to do |format|
                format.html { redirect_to(admin_user_path(@user)) }
              end
            else
              respond_to do |format|
                format.html do
                  flash[:error] = "You cannot suspend yourself."
                  redirect_to(admin_user_path(@user))
                end
              end
            end
          end

          def reset_password
            @user = User.find(params[:id])
            @user.login.reset_password!
            respond_to do |format|
              format.html do
                flash[:notice] = "Password reset sent"
                redirect_to(admin_user_path(@user))
              end
            end
          end

          def administrator
            @user = User.find(params[:id])
            unless i_am? @user
              if @user.update_attribute(:administrator, (@user.administrator.present? ? false : true))
                flash[:notice] = "User administrator permissions updated"
              else
                flash[:error] = "Something went wrong and permissions were not changed"
              end
            else
              flash[:error] = "I'm sorry Dave, I can't let you do that!"
            end
            respond_to do |format|
              format.html { redirect_to(admin_user_path(@user)) }
            end
          end

        end
      end
    end
  end
end

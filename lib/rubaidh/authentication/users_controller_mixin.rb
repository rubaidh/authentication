module Rubaidh
  module Authentication
    module UsersControllerMixin
      def self.included(controller)
        controller.send(:include, InstanceMethods)
        controller.class_eval do
          skip_before_filter :login_required, :only => [:show, :new, :create, :activate]
        end
      end

      module InstanceMethods
        def show
          respond_to do |format|
            format.html { redirect_to new_user_path }
          end
        end

        def new
          @user = User.new

          respond_to do |format|
            format.html # new.html.erb
          end
        end

        def create
          @user = User.new(params[:user])

          respond_to do |format|
            if @user.save
              format.html # create.html.erb
            else
              format.html { render :action => "new" }
            end
          end
        end

        def activate
          @user = User.find_by_activation_code(params[:activation_code])
          respond_to do |format|
            if @user.present? && @user.activate
              self.current_user = @user
              format.html do
                flash[:notice] = "Account successfully activated, thank you"
                redirect_to(root_url)
              end
            else
              format.html do
                flash[:error] = "There was an error activating your account."
                redirect_to(new_session_url)
              end
            end
          end
        end

      end
    end
  end
end

module Rubaidh
  module Authentication
    module UsersControllerMixin
      def self.included(controller)
        controller.send(:include, InstanceMethods)
        controller.class_eval do
          skip_before_filter :login_required, :only => [:show, :new, :create]
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
      end
    end
  end
end

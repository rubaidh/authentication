module Rubaidh
  module Authentication
    module ActivationsControllerMixin

      def self.included(controller)
        controller.send(:include, InstanceMethods)

        controller.class_eval do
          login_not_required :for => [:new, :create]
        end
      end

      module InstanceMethods
        def new
          respond_to do |format|
            format.html # new.html
          end
        end

        def create
          @login = Login.find_by_email(params[:email])
          if @login.present? && @login.pending?
            @login.resend_activation!
            flash[:notice] = "Your activation email has been resent."
            redirect_to login_url
          else
            flash[:error] = "The email address you specified does not have a pending account associated with it."
            render :action => 'new'
          end
        end
      end
    end
  end
end

module Rubaidh
  module Authentication
    module LoginsControllerMixin

      def self.included(controller)
        controller.send(:include, InstanceMethods)
        controller.class_eval do
          login_not_required :for => [:activate]
        end
      end

      module InstanceMethods
        def activate
          @login = Login.find_by_activation_code(params[:activation_code])
          respond_to do |format|
            if @login.present? && @login.activate
              self.current_login = @login
              format.html do
                flash[:notice] = "Login account successfully activated, thank you"
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

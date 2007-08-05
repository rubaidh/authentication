module Rubaidh
  module Spec
    module Matchers
      class RequireLogin < ::Spec::Rails::Matchers::RedirectTo #:nodoc:

        def initialize(request)
          @expected = '/session/new'
          @request = request
        end

        def failure_message
          if @redirected
            return %Q{expected redirect to login page, got redirect to #{@actual.inspect}}
          else
            return %Q{expected redirect to login page, got no redirect}
          end
        end

        def negative_failure_message
          return %Q{did not expect to be redirected to login page, but was}
        end

        def description
          "require login"
        end
      end

      # :call-seq:
      #   response.should require_login
      #
      # Passes if the response requires a login, before it can continue
      #
      # == Examples
      #
      #   response.should require_login
      def require_login()
        RequireLogin.new(request)
      end
    end
  end
end

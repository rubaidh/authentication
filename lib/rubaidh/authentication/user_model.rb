require 'md5'
require 'bcrypt'

module Rubaidh
  module Authentication

    module UserModel
      module ActMethods
        def rubaidh_authentication(options = {})
          options[:login_field] ||= :login
          options[:login_field] = options[:login_field].to_sym

          class_inheritable_accessor :acts_as_login_options
          self.acts_as_login_options = options
          
          # Only do these bits once per class, even if we're called, for some
          # twisted reason, several times.
          unless included_modules.include?(InstanceMethods)
            include InstanceMethods
            extend ClassMethods

            # Virtual attribute for the unencrypted password
            attr_accessor :password

            # Pretend we have an accessor called remember_me so that the form helpers
            # work for login
            attr_reader :remember_me

            validates_presence_of     acts_as_login_options[:login_field]
            validates_uniqueness_of   acts_as_login_options[:login_field], :case_sensitive => false
            validates_length_of       acts_as_login_options[:login_field], :within => 3..100

            class_eval <<-RUBY
              def self.find_by_#{acts_as_login_options[:login_field]}_and_password(login, password)
                u = find_by_#{acts_as_login_options[:login_field]}(login)
                u && u.authenticated?(password) ? u : nil
              end
            RUBY

            validates_presence_of     :password, :if => :password_required?
            validates_presence_of     :password_confirmation, :if => :password_required?
            validates_length_of       :password, :within => 4..40, :if => :password_required?
            validates_confirmation_of :password, :if => :password_required?

            before_validation :encrypt_virtual_password_unless_blank
            
            if options[:activation]
              include Activation::InstanceMethods
              before_create :set_activation_code

              # State Machine information
              acts_as_state_machine :initial => :unconfirmed
              state :unconfirmed, :enter => :mail_activation_code
              state :confirmed, :enter => :clear_activation_code

              event :confirm_email_address do
                transitions :from => :unconfirmed, :to => :confirmed
              end
            end
          end
        end
      end

      module ClassMethods
        def generate_hash
          MD5.hexdigest(BCrypt::Engine.generate_salt)
        end
      end
      
      module InstanceMethods
        def crypted_password
          BCrypt::Password.new(read_attribute('crypted_password')) unless read_attribute('crypted_password').blank?
        end

        def authenticated?(password)
          self.crypted_password == password
        end

        def remember_token?
          remember_token_expires_at && Time.now.utc < remember_token_expires_at 
        end

        def remember_me_for(time)
          remember_me_until time.from_now.utc
        end

        def remember_me_until(time)
          self.remember_token_expires_at = time
          self.remember_token            = self.class.generate_hash
          save(false)
        end

        def forget_me
          self.remember_token_expires_at = nil
          self.remember_token            = nil
          save(false)
        end

        protected
        def password_required?
          crypted_password.blank? || !password.blank?
        end

        def encrypt_virtual_password_unless_blank
          write_attribute('crypted_password', BCrypt::Password.create(self.password)) unless self.password.blank?
        end
      end
      
      module Activation
        module InstanceMethods
          private
          def clear_activation_code
            self.activation_code = nil
          end

          def set_activation_code
            self.activation_code = self.class.generate_hash
          end
          
          def mail_activation_code
            Notifications.deliver_activation(self)
          end
        end
      end
    end
  end
end
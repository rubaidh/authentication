# Login Specification
#
# Created on April 20, 2009 17:00 by Mark Connell as part
# of the "Login app" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Login do
  describe "generator" do
    it "should successfully create a new instance" do
      lambda { Login.generate! }.should_not raise_error
    end

    it "should persist the new instance in the database" do
      lambda { Login.generate }.should change(Login, :count).by(1)
    end

    it "should be valid" do
      Login.generate.should be_valid
    end
  end

  describe "named scopes" do
    describe "inactive" do
      it "should return any objects not 'active'" do
        pending = Login.generate!
        active = Login.generate!(:state => 'active')
        suspended = Login.generate(:state => 'suspended')
        deleted = Login.generate(:state => 'deleted')

        Login.inactive.should be_include(pending)
        Login.inactive.should be_include(suspended)
        Login.inactive.should be_include(deleted)
        Login.inactive.should_not be_include(active)
      end
    end
  end

  describe "validations" do

    describe "username attribute" do
      it "should be between 3 and 255 characters" do
        login = Login.generate(:username => 'az')
        login.should_not be_valid

        login = Login.generate(:username => ("x"*256))
        login.should_not be_valid

        login = Login.generate(:username => "Joe_Bloggs_123")
        login.should be_valid
      end

      it "should be unique" do
        login_one = Login.generate(:username => 'wally')
        login_one.should be_valid

        login_two = Login.generate(:username => 'wally')
        login_two.should_not be_valid

        login_three = Login.generate(:username => 'wally123')
        login_three.should be_valid
      end
    end

    describe "email attribute" do
      it "should require its presence" do
        login = Login.generate(:email => nil)
        login.should_not be_valid
      end

      it "should be between 6 and 100 characters in length" do
        login = Login.generate(:email => 'x@y.z')
        login.should_not be_valid

        login = Login.generate(:email => 'mark@rubaidh.com')
        login.should be_valid

        login = Login.generate(:email => ("x"*96 + "@.com"))
        login.should_not be_valid
      end

      it "should be unique" do
        login_one = Login.generate(:username => "foo", :email => 'mark@rubaidh.com')
        login_one.should be_valid

        login_two = Login.generate(:username => "bar", :email => 'mark@rubaidh.com')
        login_two.should_not be_valid

        login_three = Login.generate(:username => 'baz', :email => 'support@rubaidh.com')
        login_three.should be_valid
      end
    end

    describe "passwords" do
      describe "form inputs (password and password_confirmation)" do
        it "should require a password" do
          login = Login.generate(:password => nil)
          login.should_not be_valid
          login.should have_at_least(1).error_on(:password)
        end

        it "should require a password confirmation" do
          login = Login.generate(:password_confirmation => nil)
          login.should_not be_valid
          login.should have(1).error_on(:password_confirmation)
        end

        it "should require password and password_confirmation match" do
          login = Login.generate(:password => 'foo', :password_confirmation => 'bar')
          login.should_not be_valid
          login.should have(1).error_on(:password)

          login = Login.generate(:password => 'foobar', :password_confirmation => 'foobar')
          login.should be_valid
        end

        it "should not require a plaintext password to be entered if there is an encrypted password stored already" do
          login = Login.generate(:password => nil, :password_confirmation => nil, :crypted_password => 'goobldygook', :salt => 'goobbldygook')
          login.should be_valid
        end
      end

      describe "encypted password" do
        it "should require an encrypted password" do
          login = Login.generate(:password => nil, :crypted_password => nil)
          login.should_not be_valid

          login = Login.generate # with defaults from exemplar
          login.should be_valid
        end
      end
    end
  end

  describe "publicly accessible methods" do
    describe "secure_digest" do
      it "should take any number of arguements, join them and return a sha1 hash" do
        Login.secure_digest(123).should == "40bd001563085fc35165329ea1ff5c5ecbdbbeef"
        Login.secure_digest("wibble","wobble").should == "d6c73ae5231b95f16b5958243ae00e940a0ff9a9"
      end
    end

    describe "generate_hash" do
      it "should take the current time and the app name and return a 40-digit sha1 hash" do
        Login.generate_hash.length.should == 40
      end
    end

    describe "remember_me" do
      before(:each) do
        @login = Login.generate
        @login.remember_me
      end

      it "should set the remember_token and expiry" do
        @login.remember_token.should_not be_blank
        @login.remember_token_expires_at.should_not be_blank
      end
    end

    describe "forget_me" do
      before(:each) do
        @login = Login.generate
        @login.remember_me
        @login.forget_me
      end

      it "should set the remember_token and expiry to nil" do
        @login.remember_token.should be_blank
        @login.remember_token_expires_at.should be_blank
      end
    end

    describe "correct_password?" do
      it "should return false if the passwords don't match" do
        login = Login.generate(:password => 'foobar', :password_confirmation => 'foobar')
        login.correct_password?('incorrect password').should == false
        login.correct_password?('foobar').should == true
      end
    end

    describe "self.authenticate" do
      describe "for an active user" do
        before(:each) do
          @login = Login.generate(:username => 'Bob', :password => "foobar", :password_confirmation => "foobar", :state => 'active')
        end

        describe "with correct credentials" do
          it "should return the user object" do
            Login.authenticate('Bob', 'foobar').should == @login
          end
        end

        describe "with incorrect credentials" do
          it "should return nil" do
            Login.authenticate('Bob', 'wooozle').should == nil
          end
        end
      end

      describe "for a pending user" do
        before(:each) do
          @login = Login.generate(:username => 'Test', :password => 'foobar', :password_confirmation => 'foobar', :state => 'pending')
        end

        describe "with correct credentials" do
          it "should return nil (not authenticate)" do
            Login.authenticate('Test', 'foobar').should == nil
          end
        end

        describe "with incorrect credentials" do
          it "should return nil (not authenticate)" do
            Login.authenticate('Test', 'wooooozle').should == nil
          end
        end
      end

      describe "for a suspended user" do
        before(:each) do
          @login = Login.generate(:username => 'Test', :password => 'foobar', :password_confirmation => 'foobar', :state => 'suspended')
        end

        describe "with correct credentials" do
          it "should return nil (not authenticate)" do
            Login.authenticate('Test', 'foobar').should == nil
          end
        end

        describe "with incorrect credentials" do
          it "should return nil (not authenticate)" do
            Login.authenticate('Test', 'wooozledoozle').should == nil
          end
        end
      end
    end

    describe "resend_activation!" do
      before(:each) do
        @login = Login.generate
        LoginMailer.stub!(:deliver_activation_request)
      end

      it "should make a call on LoginMailer.deliver_activation_request" do
        LoginMailer.should_receive(:deliver_activation_request)
        @login.resend_activation!
      end
    end

    describe "reset_password!" do
      before(:each) do
        @login = Login.generate
        LoginMailer.stub!(:deliver_password_reset)
      end

      it "should reset the password on a Login object" do
        original_password = @login.password
        @login.reset_password!
        @login.password.should_not == original_password
      end

      it "should make a call to LoginMailer.deliver_password_reset" do
        LoginMailer.should_receive(:deliver_password_reset)
        @login.reset_password!
      end
    end

    describe "self.generate_random_password" do
      it "should generate a string" do
        Login.generate_random_password.class.should == String
      end

      it "should create a unique password each time" do
        Login.generate_random_password.should_not == Login.generate_random_password
      end
    end

    describe "update_password" do
      before(:each) do
        @login = Login.generate(:password => 'old_password', :password_confirmation => 'old_password')
      end

      it "should save a new password if valid" do
        old_password = @login.password
        @login.update_password('foobar', 'foobar')
        @login.reload
        @login.password != old_password
      end
    end
  end

  describe "state machine transitions" do
    describe "when object has 'new' state" do
      it "should have a 'new' state" do
        login = Login.generate
        login.state.should == "new"
      end

      it "should have three state events available to access" do
        login = Login.generate
        login.state_events.size.should == 3
      end

      it "should have request_activation,suspend and mark_deleted available to access" do
        login = Login.generate
        login.can_request_activation?.should == true
        login.can_suspend?.should == true
        login.can_mark_deleted?.should == true
      end

      describe "transition to pending" do
        it "should transition to pending on 'request_activation'" do
          login = Login.generate
          login.request_activation.should == true
          login.state.should == "pending"
        end

        it "should make sure activated at in the login object is blank" do
          login = Login.generate
          login.request_activation
          login.activated_at.should be_blank
        end

        it "should generate an activation code" do
          login = Login.generate
          login.request_activation
          login.activation_code.should_not be_blank
          login.activation_code.size.should == 40
        end
      end

      it "should transition to suspended on 'suspend'" do
        login = Login.generate
        login.suspend.should == true
        login.state.should == 'suspended'
      end

      it "should transition to deleted on 'mark_deleted'" do
        login = Login.generate
        login.deleted_at.should == nil
        login.mark_deleted.should == true
        login.deleted_at.should_not == nil
      end
    end

    describe "when object has 'pending' state" do
      before(:each) do
        @login = Login.generate
        @login.request_activation
      end

      it "should have a 'pending' state" do
        @login.state.should == 'pending'
      end

      it "should have activate, suspend and delete available to access" do
        @login.can_activate?.should == true
        @login.can_suspend?.should == true
        @login.can_mark_deleted?.should == true
      end

      describe "transition to active" do
        it "should transition to 'active' on 'activate'" do
          @login.activate.should == true
          @login.state.should == 'active'
        end

        it "should set the activated_at attribute" do
          @login.activated_at.should be_blank
          @login.activate
          @login.activated_at.should_not be_blank
        end

        it "should set the activation code to be nil" do
          @login.activation_code.should_not be_blank
          @login.activate
          @login.activation_code.should be_blank
        end
      end

      describe "transition to suspended" do
        it "should transition to 'suspended' on 'suspend'" do
          @login.suspend.should == true
          @login.state.should == 'suspended'
        end

        it "should nil the activation code" do
          @login.suspend
          @login.activation_code.should be_blank
        end
      end

      describe "transition to deleted" do
        it "should transition to 'deleted' on 'mark_deleted" do
          @login.mark_deleted.should == true
          @login.state.should == 'deleted'
        end

        it "should set the deleted_at column" do
          @login.mark_deleted
          @login.deleted_at.should_not be_blank
        end
      end
    end

    describe "when object has 'active' state" do
      before(:each) do
        @login = Login.generate
        @login.request_activation
        @login.activate
      end

      it "should have 2 possible transitions" do
        @login.state_events.size.should == 2
        @login.can_suspend?.should == true
        @login.can_mark_deleted?.should == true
      end
    end

    describe "when object has 'suspended' state" do
      before(:each) do
        @login = Login.generate
        @login.suspend
      end

      it "should nil the activated_at column" do
        @login.activated_at.should be_blank
      end

      it "should have a suspended state" do
        @login.state.should == 'suspended'
      end

      it "should be able to transition to active" do
        @login.can_activate?.should == true
      end

      it "should transition to active when activate is called" do
        @login.activate.should == true
        @login.state == 'active'
      end
    end

    describe "when object has 'deleted' state" do
      before(:each) do
       @login = Login.generate
       @login.mark_deleted
      end

      it "should nil the activate info" do
        @login.activation_code.should be_blank
        @login.activated_at.should be_blank
        @login.deleted_at.should_not be_blank
      end

      it "should be reactivateable" do
        @login.can_activate?.should == true
      end

      it "should remove the deleted info when activated" do
        @login.activate
        @login.deleted_at.should be_blank
        @login.activated_at.should_not be_blank
        @login.state.should == 'active'
      end
    end
  end
end

# Logins Controller Spec
#
# Created on April 21, 2009 18:13 by Mark Connell as part
# of the "Login app" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LoginsController do

  describe "responding to GET activate" do
    before(:each) do
      @login = Login.generate
      @login.request_activation
    end

    def do_get
      get :activate, :activation_code => @login.activation_code
    end

    def do_get_with_invalid
      get :activate, :activation_code => "woozle"
    end

    describe "with a valid activation code" do
      before(:each) do
        Login.stub!(:find_by_activation_code).and_return(@login)
      end

      it "should ask the model for the login associated with that activation code" do
        Login.should_receive(:find_by_activation_code).with(@login.activation_code)
        do_get
      end

      it "should call #activate on the user" do
        @login.should_receive(:activate).and_return(true)
        do_get
      end

      it "should redirect back to the login page" do
        do_get
        response.should be_redirect
        response.should redirect_to(root_url)
      end

      it "should set a flash notice message" do
        do_get
        flash[:notice].should_not be_blank
      end

      it "should set current_user to be the @login" do
        do_get
        controller.send(:current_login).should == @login
      end
    end

    describe "with an invalid activation code" do
      before(:each) do
        Login.stub!(:find_by_activation_code).and_return(nil)
      end

      it "should ask the model for the login associated with that activation code" do
        Login.should_receive(:find_by_activation_code).with(@login.activation_code)
        do_get
      end

      it "should set a flash error message" do
        do_get
        flash[:error].should_not be_blank
      end

      it "should redirect back to the login page" do
        do_get
        response.should be_redirect
        response.should redirect_to(new_session_path)
      end
    end
  end
end

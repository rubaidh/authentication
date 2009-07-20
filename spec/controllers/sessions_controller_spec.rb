# Sessions Controller Spec
#
# Created on April 21, 2009 10:38 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do

  describe "responding to GET new" do
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render the 'new' template" do
      do_get
      response.should render_template(:new)
    end
  end

  describe "responding to POST create" do
    def do_post
      post :create, :email => 'email', :password => 'password'
    end

    def do_post_with_remember_me
      post :create, :email => 'email', :password => 'password', :remember_me => "1"
    end


    describe "with a correct password but without remember me" do
      before(:each) do
        @user = User.generate
        User.stub!(:authenticate).and_return(@user)
      end

      it "should authenticate the user" do
        User.should_receive(:authenticate).with('email', 'password')
        do_post
      end

      it "should set the user id to be a session variable" do
        do_post
        session[:user_id].should == @user.id
      end

      it "should capture the last_logged in at date" do
        @user.should_receive(:last_logged_in_at)
        do_post
      end

      it "should render a flash notice" do
        do_post
        flash[:notice].should_not be_empty
      end
    end

    describe "with a correct password and with remember me" do
      before(:each) do
        @user = User.generate
        User.stub!(:authenticate).and_return(@user)
      end

      it "should authenticate the user" do
        User.should_receive(:authenticate).with('email', 'password')
        do_post_with_remember_me
      end

      it "should set the login id to be a session variable" do
        do_post_with_remember_me
        session[:user_id].should == @user.id
      end

      it "should render a flash notice" do
        do_post_with_remember_me
        flash[:notice].should_not be_empty
      end

      it "should set the @login remember token" do
        do_post_with_remember_me
        @user.remember_token.should_not be_blank
        @user.remember_token_expires_at.should_not be_blank
      end
    end

    describe "with an incorrect password" do
      before(:each) do
        User.stub!(:authenticate).and_return(nil)
      end

      it "should attempt to authenticate the user" do
        User.should_receive(:authenticate).with('email', 'password')
        do_post
      end

      it "should render an error message in the flash" do
        do_post
        flash[:error].should_not be_empty
      end

      it "should render the new template" do
        do_post
        response.should render_template(:new)
      end
    end
  end

  describe "responding to DELETE destroy" do
    def do_delete
      delete :destroy
    end

    it "should set a flash notice message" do
      do_delete
      flash[:notice].should_not be_blank
    end

    it "should clear the session variable" do
      do_delete
      session[:login_id].should be_blank
    end
  end

  describe "store_location" do
    before(:each) do
      controller.stub!(:request)
    end

    it "should set the return_uri to be the http_referer if it exists" do
      controller.request.stub!(:env).and_return({'HTTP_REFERER' => "foobar"})
      controller.send(:store_location)
      session[:return_uri].should == 'foobar'
    end
  end
end

# User Controller Spec
#
# Created on April 29, 2009 11:35 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  describe "responding to GET show" do
    def do_get
      get :show
    end

    it "should redirect to the new action" do
      do_get
      response.should redirect_to(new_user_url)
    end
  end

  describe "responding to GET new" do
    before(:each) do
      @user = User.generate
      User.stub!(:new).and_return(@user)
    end

    def do_get
      get :new
    end

    it "should render the new template" do
      do_get
      response.should render_template(:new)
    end

    it "should ask the model for a new user object" do
      User.should_receive(:new)
      do_get
    end

    it "should expose a new user as @user" do
      do_get
      assigns[:user].should equal(@user)
    end
  end

  describe "responding to POST create" do
    before(:each) do
      @user = User.generate
      User.stub!(:new).and_return(@user)
      @user.stub!(:save)
    end

    def do_post
      post :create, :user => { "dummy" => "parameters" }
    end

    it "should build a new user with the supplied parameters" do
      User.should_receive(:new).with({ "dummy" => "parameters" })
      do_post
    end

    it "should attempt to save the new user" do
      @user.should_receive(:save)
      do_post
    end

    describe "with valid params" do
      before(:each) do
        @user.stub!(:save).and_return(true)
      end

      it "should redirect to the created user" do
        do_post
        response.should render_template(:create)
      end
    end

    describe "with invalid params" do
      before(:each) do
        @user.stub!(:save).and_return(false)
      end

      it "should expose a newly created but unsaved user as @user" do
        do_post
        assigns(:user).should equal(@user)
      end

      it "should re-render the 'new' template" do
        do_post
        response.should render_template(:new)
      end
    end
  end

  describe "responding to GET activate" do
    before(:each) do
      @user = User.generate
      @user.request_activation
    end

    def do_get
      get :activate, :activation_code => @user.activation_code
    end

    def do_get_with_invalid
      get :activate, :activation_code => "woozle"
    end

    describe "with a valid activation code" do
      before(:each) do
        User.stub!(:find_by_activation_code).and_return(@user)
      end

      it "should ask the model for the login associated with that activation code" do
        User.should_receive(:find_by_activation_code).with(@user.activation_code)
        do_get
      end

      it "should call #activate on the user" do
        @user.should_receive(:activate).and_return(true)
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

      it "should set current_user to be the @user" do
        do_get
        controller.send(:current_login).should == @user
      end
    end

    describe "with an invalid activation code" do
      before(:each) do
        User.stub!(:find_by_activation_code).and_return(nil)
      end

      it "should ask the model for the login associated with that activation code" do
        User.should_receive(:find_by_activation_code).with(@user.activation_code)
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

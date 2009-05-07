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
      @user = User.generate(:login => Login.generate)
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
      @user = User.generate(:login => Login.generate)
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
end

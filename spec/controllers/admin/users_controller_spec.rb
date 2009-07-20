# Admin::Users Controller Spec
#
# Created on May 01, 2009 13:46 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::UsersController do
  before(:each) do
    @user = generate_user(:administrator => true)
    @users = [@user]
  end

  describe "responding to GET index" do
    def do_get
      get :index
    end

    describe "while logged in as an admin" do
      before(:each) do
        login :administrator
        User.stub!(:active).and_return(@users)
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render the 'index' template" do
        do_get
        response.should render_template(:index)
      end

      it "should receive a find on the User model" do
        User.should_receive(:active)
        do_get
      end

      it "should assign @users to the view" do
        do_get
        assigns(:users).should == @users
      end
    end
  end

  describe "responding to GET inactive" do
    def do_get
      get :inactive
    end

    describe "while logged in as an admin" do
      before(:each) do
        login :administrator
        User.stub!(:inactive).and_return(@users)
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render the 'index' template" do
        do_get
        response.should render_template(:inactive)
      end

      it "should receive a find on the User model" do
        User.should_receive(:inactive)
        do_get
      end

      it "should assign @users to the view" do
        do_get
        assigns(:users).should == @users
      end
    end
  end

  describe "responding to GET show" do
    before(:each) do
      login :administrator
      User.stub!(:find).and_return(@user)
    end

    def do_get
      get :show, :id => "123"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render the show template" do
      do_get
      response.should render_template(:show)
    end

    it "should receive a find on User" do
      User.should_receive(:find).with("123")
      do_get
    end

    it "should assign @user to the view" do
      do_get
      assigns(:user).should == @user
    end
  end

  describe "responding to GET edit" do
    before(:each) do
      login :administrator
      User.stub!(:find).and_return(@user)
    end

    def do_get
      get :edit, :id => '123'
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render the edit template" do
      do_get
      response.should render_template(:edit)
    end

    it "should receive a find on User" do
      User.should_receive(:find).with("123")
      do_get
    end

    it "should assign @user to the view" do
      do_get
      assigns(:user).should == @user
    end
  end

  describe "responding to PUT update" do
    before(:each) do
      login :administrator
      User.stub!(:find).and_return(@user)
    end

    def do_put
      put :update, :id => '123', :user => {:first_name => 'zoogawooga'}
    end

    describe "with valid details" do
      before(:each) do
        @user.stub!(:update_attributes).and_return(true)
      end

      it "should receive a find on user" do
        User.should_receive(:find)
        do_put
      end

      it "should flash a notice" do
        do_put
        flash[:notice].should_not be_blank
      end

      it "should redirect to the user page" do
        do_put
        response.should redirect_to(admin_user_path(@user))
      end
    end

    describe "with invalid details" do
      before(:each) do
        @user.stub!(:update_attributes).and_return(false)
      end

      it "should render the edit template" do
        do_put
        response.should render_template(:edit)
      end
    end
  end

  describe "responding to DELETE destroy" do
    before(:each) do
      login :administrator
      User.stub!(:find).and_return(@user)
      User.stub!(:delete)
    end

    def do_delete
      delete :destroy, :id => '123'
    end

    it "should call find on User" do
      User.should_receive(:find)
      do_delete
    end

    it "should mark the user login as deleted" do
      @user.should_receive(:mark_deleted)
      do_delete
    end

    it "should redirect back to the listing page" do
      do_delete
      response.should redirect_to(admin_users_path)
    end

    describe "scenario where you try to delete yourself" do
      before(:each) do
        controller.stub!(:current_user).and_return(@user)
      end

      it "should have the same generated object for user that we will try to delete" do
        controller.send(:current_user).should == @user
        do_delete
      end

      it "should not call user.mark_deleted" do
        @user.should_not_receive(:mark_deleted)
        do_delete
      end

      it "should redirect to the user page" do
        do_delete
        response.should redirect_to(admin_user_path(@user))
      end

      it "should flash an error" do
        do_delete
        flash[:notice].should be_blank
        flash[:error].should_not be_blank
      end
    end
  end

  describe "responding to POST activate" do
    before(:each) do
      login :administrator
      User.stub!(:find).and_return(@user)
    end

    def do_put
      put :activate, :id => '123'
    end

    it "should find a user object" do
      User.should_receive(:find).with('123')
      do_put
    end

    it "should activate an account that isn't active" do
      @user.state.should == 'pending'
      @user.should_receive(:activate).and_return(true)
      do_put
    end

    it "should not try to reactiavte an active account" do
      @user.activate
      @user.state.should == 'active'
      @user.should_not_receive(:activate)
      do_put
    end
  end

  describe "responding to POST suspend" do
    before(:each) do
      login :administrator
      User.stub!(:find).and_return(@user)
    end

    def do_put
      put :suspend, :id => '123'
    end

    it "should find a user object" do
      User.should_receive(:find).with('123')
      do_put
    end

    it "should suspend an account that isn't suspended" do
      @user.state.should == 'pending'
      @user.should_receive(:suspend).and_return(true)
      do_put
    end

    it "should not try to resuspend a suspended account" do
      @user.suspend
      @user.state.should == 'suspended'
      @user.should_not_receive(:suspend)
      do_put
    end

    describe "scenario where you try to suspend yourself" do
      before(:each) do
        controller.stub!(:current_user).and_return(@user)
      end

      it "should have the same generated object for login that we will try to suspend" do
        controller.send(:current_user).should == @user
        do_put
      end

      it "should not call object.delete" do
        @user.should_not_receive(:suspend)
        do_put
      end

      it "should redirect to the user page" do
        do_put
        response.should redirect_to(admin_user_path(@user))
      end

      it "should flash an error" do
        do_put
        flash[:notice].should be_blank
        flash[:error].should_not be_blank
      end
    end
  end

  describe "responding to PUT reset_password" do
    before(:each) do
      login :administrator
      User.stub!(:find).and_return(@user)
    end

    def do_put
      put :reset_password, :id => '123'
    end

    it "should find a user object" do
      User.should_receive(:find).with('123')
      do_put
    end

    it "should call reset_password! on the login object associated with the user" do
      @user.should_receive(:reset_password!)
      do_put
    end
  end

  describe "responding to PUT administrator" do
    before(:each) do
      login :administrator
      User.stub!(:find).and_return(@user)
      @user.stub!(:update_attribute).and_return(true)
    end

    def do_put
      put :administrator, :id => '123'
    end

    it "should find a User object" do
      User.should_receive(:find).with('123')
      do_put
    end

    it "should redirect back to the user page" do
      do_put
      response.should redirect_to(admin_user_path(@user))
    end

    describe "when the user is self" do
      before(:each) do
        controller.stub!(:current_user).and_return(@user)
      end

      it "should not allow the administrator setting to be changed" do
        do_put
        flash[:error].should_not be_blank
      end
    end
  end
end

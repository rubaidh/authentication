# Passwords Controller Spec
#
# Created on April 29, 2009 14:30 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordsController do
  before(:each) do
    @user = User.generate
  end

  describe "responding to GET 'new'" do
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  end

  describe "responding to Get 'edit'" do
    def do_get
      get :edit
    end

    describe "while not logged in" do
      it "should not be successful" do
        do_get
        response.should_not be_success
      end

      it "redirect to the login url" do
        do_get
        response.should redirect_to(login_url)
      end
    end

    describe "while logged in" do
      before(:each) do
        controller.stub!(:current_user).and_return(@user)
      end

      it "should be successful" do
        do_get
        response.should be_success
      end

      it "should render the 'edit' template" do
        do_get
        response.should render_template(:edit)
      end

      it "should assign @user to the view" do
        do_get
        assigns(:user).should be_instance_of(User)
      end
    end
  end

  describe "responding to POST 'create'" do
    before(:each) do
      controller.stub!(:current_user).and_return(@user)
    end

    def do_post
      post :create, :email => @user.email
    end

    it "should expect a find_by_email on the Login model" do
      User.should_receive(:find_by_email)
      do_post
    end

    describe "with a valid email address" do
      before(:each) do
        User.stub!(:find_by_email).and_return(@user)
      end

      it "should make a call to reset_password!" do
        @user.should_receive(:reset_password!)
        do_post
      end

      it "should flash a notice" do
        do_post
        flash[:notice].should_not be_blank
      end

      it "should redirect to the login_url" do
        do_post
        response.should redirect_to(login_url)
      end
    end

    describe "with an invalid email address" do
      before(:each) do
        User.stub!(:find_by_email).and_return(nil)
      end

      it "should flash an error" do
        do_post
        flash[:error].should_not be_blank
      end

      it "should render the 'new' template" do
        do_post
        response.should render_template(:new)
      end
    end
  end

  describe "responding to PUT update" do
    def do_put
      put :update
    end

    describe "while not logged in" do
      it "should not be successful" do
        do_put
        response.should_not be_success
      end

      it "redirect to the login url" do
        do_put
        response.should redirect_to(login_url)
      end
    end

    describe "while logged in" do
      before(:each) do
        controller.stub!(:current_login).and_return(@user)
      end

      it "should be successful" do
        do_put
        response.should be_success
      end

      describe "when successfully updated" do
        before(:each) do
          @user.stub!(:update_password).and_return(true)
        end

        it "should flash a notice" do
          do_put
          flash[:notice].should_not be_blank
        end

        it "should redirect to the root_url" do
          do_put
          response.should redirect_to(root_url)
        end
      end

      describe "when not updated" do
        before(:each) do
          @user.stub!(:update_password).and_return(false)
        end
        it "should render the 'edit' template" do
          do_put
          response.should render_template(:edit)
        end
      end
    end
  end
end

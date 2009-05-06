# Authenticatable Controller Spec
#
# Created on April 21, 2009 11:26 by Mark Connell as part
# of the "Login app" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class DummyRestfulController < AuthenticatableController
  def index
    render :nothing => true
  end

  def show
    render :nothing => true
  end

  def new
    render :nothing => true
  end

  def create
    render :nothing => true
  end

  def edit
    render :nothing => true
  end

  def update
    render :nothing => true
  end

  def destroy
    render :nothing => true
  end
end

class LoginRequiredForAllActionsController < DummyRestfulController
  login_required
end

class LoginNotRequiredForAnyActionsController < LoginRequiredForAllActionsController
  login_not_required
end

class LoginRequiredForSomeActionsController < DummyRestfulController
  login_required :for => [ :new, :edit, :create, :update, :destroy ]
end

class LoginNotRequiredForSomeActionsController < LoginRequiredForAllActionsController
  login_not_required :for => [ :index, :show ]
end

describe "Authentication" do
  before(:all) do
    ActionController::Routing::Routes.draw do |map|
      map.resources :login_required_for_all_actions
      map.resources :login_not_required_for_any_actions
      map.resources :administrator_login_required_for_all_actions
      map.resources :login_required_for_some_actions
      map.resources :login_not_required_for_some_actions

      map.resource :session
    end
  end

  after(:all) do
    ActionController::Routing::Routes.reload!
  end

  describe LoginRequiredForAllActionsController do
    describe "without logging in" do
      it "should redirect to the login page for index" do
        get :index
        response.should redirect_to(login_url)
      end

      it "should redirect to the login page for show" do
        get :show, :id => 1
        response.should redirect_to(login_url)
      end

      it "should redirect to the login page for new" do
        get :new
        response.should redirect_to(login_url)
      end

      it "should redirect to the login page for edit" do
        get :edit, :id => 1
        response.should redirect_to(login_url)
      end

      it "should redirect to the login page for create" do
        post :create
        response.should redirect_to(login_url)
      end

      it "should redirect to the login page for update" do
        put :update, :id => 1
        response.should redirect_to(login_url)
      end

      it "should redirect to the login page for destroy" do
        put :destroy, :id => 1
        response.should redirect_to(login_url)
      end
    end


    describe "after logging in" do
      before(:each) do
        login
      end

      it "should successfully render index" do
        get :index
        response.should be_success
      end

      it "should successfully render show" do
        get :show, :id => 1
        response.should be_success
      end

      it "should successfully render new" do
        get :new
        response.should be_success
      end

      it "should successfully render edit" do
        get :edit, :id => 1
        response.should be_success
      end

      it "should successfully render create" do
        post :create
        response.should be_success
      end

      it "should successfully render update" do
        put :update, :id => 1
        response.should be_success
      end

      it "should successfully render destroy" do
        put :destroy, :id => 1
        response.should be_success
      end
    end
  end

  describe LoginNotRequiredForAnyActionsController do
    describe "without logging in" do
      it "should successfully render index" do
        get :index
        response.should be_success
      end

      it "should successfully render show" do
        get :show, :id => 1
        response.should be_success
      end

      it "should successfully render new" do
        get :new
        response.should be_success
      end

      it "should successfully render edit" do
        get :edit, :id => 1
        response.should be_success
      end

      it "should successfully render create" do
        post :create
        response.should be_success
      end

      it "should successfully render update" do
        put :update, :id => 1
        response.should be_success
      end

      it "should successfully render destroy" do
        put :destroy, :id => 1
        response.should be_success
      end
    end


    describe "after logging in" do
      before(:each) do
        login
      end

      it "should successfully render index" do
        get :index
        response.should be_success
      end

      it "should successfully render show" do
        get :show, :id => 1
        response.should be_success
      end

      it "should successfully render new" do
        get :new
        response.should be_success
      end

      it "should successfully render edit" do
        get :edit, :id => 1
        response.should be_success
      end

      it "should successfully render create" do
        post :create
        response.should be_success
      end

      it "should successfully render update" do
        put :update, :id => 1
        response.should be_success
      end

      it "should successfully render destroy" do
        put :destroy, :id => 1
        response.should be_success
      end
    end
  end

  describe LoginRequiredForSomeActionsController do
    describe "without logging in" do
      it "should successfully render index" do
        get :index
        response.should be_success
      end

      it "should successfully render show" do
        get :show, :id => 1
        response.should be_success
      end

      it "should redirect to the login page for new" do
        get :new
        response.should redirect_to(login_url)
      end

      it "should redirect to the login page for edit" do
        get :edit, :id => 1
        response.should redirect_to(login_url)
      end

      it "should redirect to the login page for create" do
        post :create
        response.should redirect_to(login_url)
      end

      it "should redirect to the login page for update" do
        put :update, :id => 1
        response.should redirect_to(login_url)
      end

      it "should redirect to the login page for destroy" do
        put :destroy, :id => 1
        response.should redirect_to(login_url)
      end
    end


    describe "after logging in" do
      before(:each) do
        login
      end

      it "should successfully render index" do
        get :index
        response.should be_success
      end

      it "should successfully render show" do
        get :show, :id => 1
        response.should be_success
      end

      it "should successfully render new" do
        get :new
        response.should be_success
      end

      it "should successfully render edit" do
        get :edit, :id => 1
        response.should be_success
      end

      it "should successfully render create" do
        post :create
        response.should be_success
      end

      it "should successfully render update" do
        put :update, :id => 1
        response.should be_success
      end

      it "should successfully render destroy" do
        put :destroy, :id => 1
        response.should be_success
      end
    end
  end

  describe LoginNotRequiredForSomeActionsController do
    describe "without logging in" do
      it "should successfully render index" do
        get :index
        response.should be_success
      end

      it "should successfully render show" do
        get :show, :id => 1
        response.should be_success
      end

      it "should redirect to the login page for new" do
        get :new
        response.should redirect_to(login_url)
      end

      it "should redirect to the login page for edit" do
        get :edit, :id => 1
        response.should redirect_to(login_url)
      end

      it "should redirect to the login page for create" do
        post :create
        response.should redirect_to(login_url)
      end

      it "should redirect to the login page for update" do
        put :update, :id => 1
        response.should redirect_to(login_url)
      end

      it "should redirect to the login page for destroy" do
        put :destroy, :id => 1
        response.should redirect_to(login_url)
      end
    end


    describe "after logging in" do
      before(:each) do
        login
      end

      it "should successfully render index" do
        get :index
        response.should be_success
      end

      it "should successfully render show" do
        get :show, :id => 1
        response.should be_success
      end

      it "should successfully render new" do
        get :new
        response.should be_success
      end

      it "should successfully render edit" do
        get :edit, :id => 1
        response.should be_success
      end

      it "should successfully render create" do
        post :create
        response.should be_success
      end

      it "should successfully render update" do
        put :update, :id => 1
        response.should be_success
      end

      it "should successfully render destroy" do
        put :destroy, :id => 1
        response.should be_success
      end
    end
  end

  describe AuthenticatableController do
    before(:all) do
      ActionController::Routing::Routes.draw do |map|
        # map route 'root_url' so we can use it
        map.root :controller => "sessions"
      end
    end

    describe "i_am? method" do
      describe "when the current_login is me" do
        before(:each) do
          @user = generate_user
          controller.send(:current_login=, @user.login)
        end

        it "should say @user is me" do
          controller.send(:i_am?, @user).should == true
        end

        it "should say @user.login is me" do
          controller.send(:i_am?, @user.login).should == true
        end
      end
    end

  end

end

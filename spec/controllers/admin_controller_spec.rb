# Admin Controller Spec
#
# Created on April 30, 2009 15:41 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class DummyAdminRestfulController < AdminController
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

class AdministratorLoginRequiredForAllActionsController < DummyAdminRestfulController
  administrator_login_required
end

class AdministratorLoginNotRequiredForAnyActionsController < AdministratorLoginRequiredForAllActionsController
  administrator_login_not_required
end

class AdministratorLoginRequiredForSomeActionsController < DummyAdminRestfulController
  administrator_login_required :for => [ :new, :edit, :create, :update, :destroy ]
end

class AdministratorLoginNotRequiredForSomeActionsController < AdministratorLoginRequiredForAllActionsController
  administrator_login_not_required :for => [ :index, :show ]
end

describe "Admin authentication (Authorisation?)" do
  before(:all) do
    ActionController::Routing::Routes.draw do |map|
      map.resources :administrator_login_required_for_all_actions
      map.resources :administrator_login_not_required_for_any_actions
      map.resources :administrator_login_required_for_some_actions
      map.resources :administrator_login_not_required_for_some_actions

      map.resource :session
    end
  end

  after(:all) do
    ActionController::Routing::Routes.reload!
  end

  describe AdministratorLoginRequiredForAllActionsController do
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

    describe "after logging in as a non administrator user" do
      before(:each) do
        generate_user # generate first user so there is an admin account
        login
      end

      it "should redirect to the login page for index" do
        lambda { get :index }.should raise_error(ActionController::Forbidden)
      end

      it "should raise Forbidden for show" do
        lambda { get :show, :id => 1 }.should raise_error(ActionController::Forbidden)
      end

      it "should raise Forbidden for new" do
        lambda { get :new }.should raise_error(ActionController::Forbidden)
      end

      it "should raise Forbidden for edit" do
        lambda { get :edit, :id => 1 }.should raise_error(ActionController::Forbidden)
      end

      it "should raise Forbidden for create" do
        lambda { post :create }.should raise_error(ActionController::Forbidden)
      end

      it "should raise Forbidden for update" do
        lambda { put :update, :id => 1 }.should raise_error(ActionController::Forbidden)
      end

      it "should raise Forbidden for destroy" do
        lambda { put :destroy, :id => 1 }.should raise_error(ActionController::Forbidden)
      end
    end

    describe "after logging in as an administrator" do
      before(:each) do
        login :administrator
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

  describe AdministratorLoginNotRequiredForAnyActionsController do
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

    describe "while logged in as a regular user" do
      before(:each) do
        generate_user # generate first user so there is an admin account
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

    describe "after logging in as admin" do
      before(:each) do
        login :administrator
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

  describe AdministratorLoginRequiredForSomeActionsController do
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

    describe "while logged in as a regular user" do
      before(:each) do
        generate_user # generate first user so there is an admin account
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

      it "should raise forbidden for new" do
        lambda{ get :new }.should raise_error(ActionController::Forbidden)
      end

      it "should raise forbidden for edit" do
        lambda { get :edit, :id => 1 }.should raise_error(ActionController::Forbidden)
      end

      it "should redirect to the login page for create" do
        lambda { post :create }.should raise_error(ActionController::Forbidden)
      end

      it "should raise forbidden for update" do
        lambda { put :update, :id => 1 }.should raise_error(ActionController::Forbidden)
      end

      it "should raise forbidden for destroy" do
        lambda { put :destroy, :id => 1 }.should raise_error(ActionController::Forbidden)
      end
    end


    describe "after logging in" do
      before(:each) do
        login :administrator
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

  describe AdministratorLoginNotRequiredForSomeActionsController do
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

    describe "while logged in as a regular user" do
      before(:each) do
        generate_user # generate first user so there is an admin account
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

      it "should raise forbidden for new" do
        lambda { get :new }.should raise_error(ActionController::Forbidden)
      end

      it "should raise forbidden for edit" do
        lambda{ get :edit, :id => 1 }.should raise_error(ActionController::Forbidden)
      end

      it "should raise forbidden for create" do
        lambda{ post :create }.should raise_error(ActionController::Forbidden)
      end

      it "should raise forbidden for update" do
       lambda { put :update, :id => 1 }.should raise_error(ActionController::Forbidden)
      end

      it "should raise forbidden for destroy" do
        lambda { put :destroy, :id => 1 }.should raise_error(ActionController::Forbidden)
      end
    end

    describe "after logging in as admin" do
      before(:each) do
        login :administrator
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
end

describe AdminController do
end

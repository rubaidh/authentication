require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::UsersController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "admin/users", :action => "index").should == "admin/users"
    end

    it "should map #show" do
      route_for(:controller => "admin/users", :action => "show", :id => "3").should == "admin/users/3"
    end

    it "should map #edit" do
      route_for(:controller => "admin/users", :action => "edit", :id => "3").should == {:path => "admin/users/3/edit",
        :method => :get}
    end

    it "should map #update" do
      route_for(:controller => "admin/users", :action => "update", :id => "3").should == {:path => "admin/users/3",
        :method => :put}
    end

    it "should map #destroy" do
      route_for(:controller => "admin/users", :action => "destroy", :id => "3").should == {:path => "admin/users/3",
        :method => :delete}
    end

    it "should map #activate" do
       route_for(:controller => "admin/users", :action => "activate", :id => "3").should == {:path => "admin/users/3/activate",
         :method => :put}
    end

    it "should map #suspend" do
      route_for(:controller => "admin/users", :action => "suspend", :id => "3").should == {:path => "admin/users/3/suspend",
        :method => :put}
    end

    it "should map #reset_password" do
      route_for(:controller => "admin/users", :action => "reset_password", :id => "3").should == {:path => "admin/users/3/reset_password",
        :method => :put}
    end

    it "should map #administrator" do
      route_for(:controller => "admin/users", :action => "administrator", :id => "3").should == {:path => "admin/users/3/administrator", :method => :put}
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/admin/users").should == {:controller => "admin/users", :action => "index"}
    end

    it "should generate params for #show" do
      params_from(:get, "/admin/users/3").should == {:controller => "admin/users", :action => "show", :id => "3"}
    end

    it "should generate params for #edit" do
      params_from(:get, "/admin/users/3/edit").should == {:controller => "admin/users", :action => "edit", :id => "3"}
    end

    it "should generate params for #update" do
      params_from(:put, "/admin/users/3").should == {:controller => "admin/users", :action => "update", :id => "3"}
    end

    it "should generate params for #destroy" do
      params_from(:delete, "/admin/users/3").should == {:controller => "admin/users", :action => "destroy", :id => "3"}
    end

    it "should generate params for #activate" do
      params_from(:put, "/admin/users/3/activate").should == {:controller => "admin/users", :action => "activate", :id => "3"}
    end

    it "should generate params for #suspend" do
      params_from(:put, "/admin/users/3/suspend").should == {:controller => "admin/users", :action => "suspend", :id => "3"}
    end

    it "should generate params for #reset_password" do
      params_from(:put, "/admin/users/3/reset_password").should == {:controller => "admin/users", :action => "reset_password", :id => "3"}
    end

    it "should generate params for #administrator" do
      params_from(:put, "/admin/users/3/administrator").should == {:controller => "admin/users", :action => "administrator", :id => "3"}
    end
  end

  describe "named routes" do
    before(:each) do
      get :new
    end

    it "should route admin_users_path to /admin/users" do
      admin_users_path.should == "/admin/users"
    end

    it "should route admin_user_path to /admin/users/:id" do
      admin_user_path(3).should == "/admin/users/3"
    end

    it "should route edit_admin_user_path to /admin/users/:id/edit" do
      edit_admin_user_path(3).should == "/admin/users/3/edit"
    end

    it "should route activate_admin_user_path to /admin/users/:id/activate" do
      activate_admin_user_path(3).should == "/admin/users/3/activate"
    end

    it "should route suspend_admin_user_path to /admin/users/:id/suspend" do
      suspend_admin_user_path(3).should == "/admin/users/3/suspend"
    end

    it "should route reset_password_admin_user_path to /admin/users/:id/reset_password" do
      reset_password_admin_user_path(3).should == "/admin/users/3/reset_password"
    end

    it "should route administrator_admin_user_path to /admin/users/:id/administrator" do
      administrator_admin_user_path(3).should == "/admin/users/3/administrator"
    end
  end
end

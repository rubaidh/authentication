require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordsController do
  describe "route generation" do
    it "should map #new" do
      route_for(:controller => "passwords", :action => "new").should == "/password/new"
    end

    it "should map #create" do
      route_for(:controller => "passwords", :action => "create").should == { :path => '/password', :method => :post }
    end

    it "should map #edit" do
      route_for(:controller => "passwords", :action => "edit").should == { :path => '/password/edit', :method => :get }
    end

    it "should map #update" do
      route_for(:controller => "passwords", :action => "update").should == { :path => '/password', :method => :put }
    end
  end

  describe "route recognition" do
    it "should generate params for #new" do
      params_from(:get, "/password/new").should == {:controller => "passwords", :action => "new"}
    end

    it "should generate params for #create" do
      params_from(:post, "/password").should == {:controller => "passwords", :action => "create"}
    end

    it "should generate params for #edit" do
      params_from(:get, "/password/edit").should == {:controller => "passwords", :action => "edit"}
    end

    it "should generate params for #update" do
      params_from(:put, "/password").should == {:controller => "passwords", :action => "update"}
    end
  end

  describe "named routes" do
    before(:each) do
      get :new
    end

    it "should route new_password_path to /password/new" do
      new_password_path.should == "/password/new"
    end

    it "should route password_path to /password" do
      password_path.should == "/password"
    end

    it "should route edit_password_path to /password/edit" do
      edit_password_path.should == "/password/edit"
    end
  end
end

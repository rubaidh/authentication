require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LoginsController do
  describe "route generation" do
    it "should map #activate" do
      route_for(:controller => "logins", :action => "activate").should == "/login/activate"
    end
  end

  describe "route recognition" do
    it "should generate params for #activate" do
      params_from(:get, "/login/activate").should == {:controller => "logins", :action => "activate"}
    end
  end

  describe "named routes" do
    it "should route activate to /login/activate" do
      activate_path.should == "/login/activate/"
    end
  end
end

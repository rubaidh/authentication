require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do
  describe "route generation" do
    it "should map #new" do
      route_for(:controller => "sessions", :action => "new").should == "/session/new"
    end

    it "should map #create" do
      route_for(:controller => "sessions", :action => "create").should == { :path => '/session', :method => :post }
    end

    # it "should map #destroy" do
    #       route_for(:controller => "sessions", :action => "destroy").should == "/session"
    #     end
  end

  describe "route recognition" do
    it "should generate params for #new" do
      params_from(:get, "/session/new").should == {:controller => "sessions", :action => "new"}
    end

    it "should generate params for #create" do
      params_from(:post, "/session").should == {:controller => "sessions", :action => "create"}
    end

    it "should generate params for #create" do
      params_from(:delete, "/session").should == {:controller => "sessions", :action => "destroy"}
    end
  end

  describe "named routes" do
    before(:each) do
      get :new
    end

    it "should route new_session_path to /session/new" do
      new_session_path.should == "/session/new"
    end

    it "should route session_path to /session" do
      session_path.should == "/session"
    end
  end
end

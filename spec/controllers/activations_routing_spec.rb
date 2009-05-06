require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActivationsController do
  describe "route generation" do
    it "should map #new" do
      route_for(:controller => "activations", :action => "new").should == "/activation/new"
    end

    it "should map #create" do
      route_for(:controller => "activations", :action => "create").should == { :path => '/activation', :method => :post }
    end
  end

  describe "route recognition" do
    it "should generate params for #new" do
      params_from(:get, "/activation/new").should == {:controller => "activations", :action => "new"}
    end

    it "should generate params for #create" do
      params_from(:post, "/activation").should == {:controller => "activations", :action => "create"}
    end
  end

  describe "named routes" do
    before(:each) do
      get :new
    end

    it "should route new_activation_path to /activation/new" do
      new_activation_path.should == "/activation/new"
    end

    it "should route acitvation_path to /activation" do
      activation_path.should == "/activation"
    end
  end
end

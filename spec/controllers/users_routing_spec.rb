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
  describe "route generation" do
    it "should map #new" do
      route_for(:controller => "users", :action => "new").should == "/user/new"
    end

    it "should map #create" do
      route_for(:controller => "users", :action => "create").should == { :path => "/user", :method => :post }
    end

    it "should map #show" do
      route_for(:controller => "users", :action => "show").should == "/user"
    end

    it "should map #activate" do
      route_for(:controller => "users", :action => "activate").should == "/user/activate"
    end
  end

  describe "route recognition" do
    it "should generate params for #new" do
      params_from(:get, "/user/new").should == {:controller => "users", :action => "new"}
    end

    it "should generate params for #create" do
      params_from(:post, "/user").should == {:controller => "users", :action => "create"}
    end

    it "should generate params for #show" do
      params_from(:get, "/user").should == {:controller => "users", :action => "show"}
    end

    it "should generate params for #activate" do
      params_from(:get, "/user/activate").should == {:controller => "users", :action => "activate"}
    end
  end

  describe "named routes" do
    it "should route activate to /user/activate" do
      activate_path.should == "/user/activate/"
    end
  end
end

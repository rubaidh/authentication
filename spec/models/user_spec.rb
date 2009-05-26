# User Specification
#
# Created on April 29, 2009 11:35 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  describe "generator" do
    it "should successfully create a new instance" do
      lambda { User.generate! }.should raise_error
    end

    it "should persist the new instance in the database" do
      lambda { User.generate }.should_not change(User, :count).by(1)
    end

    it "should be valid" do
      User.generate.should_not be_valid
    end
  end

  describe "validations" do
    it "should require the presence of a first name" do
      @user = User.generate(:first_name => nil)
      @user.should_not be_valid
    end

    it "should require the presence of a last name" do
      @user = User.generate(:last_name => nil)
      @user.should_not be_valid
    end
  end

end

# Admin Helper Spec
#
# Created on April 30, 2009 15:41 by Mark Connell as part
# of the "Login app" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdminHelper do
  describe "generate_admin_navigation" do
    it "should return a string" do
      helper.generate_admin_navigation.class.should == String
    end

    it "should include a link to the admin/users since we know it exists" do
      helper.generate_admin_navigation.should == "<ul><li><a href=\"/admin/users\">Users</a></li></ul>"
    end
  end
end

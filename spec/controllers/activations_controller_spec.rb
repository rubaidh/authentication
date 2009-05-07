# Activations Controller Spec
#
# Created on April 30, 2009 10:37 by Mark Connell as part
# of the "authentication" project.
#
#--
# Copyright (c) 2006-2009 Rubaidh Ltd.  All rights reserved.
# See LICENSE in the top level source code folder for permissions.
#++

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActivationsController do

  describe "responding to GET new" do
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render the 'new' template" do
      do_get
      response.should render_template(:new)
    end
  end

  describe "responding to POST create" do
    before(:each) do
      @login = Login.generate
      LoginMailer.stub!(:deliver_activation_request)
      Login.stub!(:find_by_email).and_return(@login)
    end

    def do_post
      post :create
    end

    it "should be successful" do
      do_post
      response.should be_success
    end

    it "should receive a find by email for Login" do
      Login.should_receive(:find_by_email)
      do_post
    end

    describe "with a pending account" do
      before(:each) do
        @login.request_activation
      end

      it "should resend the activation" do
        @login.should_receive(:resend_activation!)
        do_post
      end
    end

    describe "with an account that is active" do
      before(:each) do
        @login.request_activation
        @login.activate
      end

      it "should flash an error" do
        do_post
        flash[:error].should_not be_blank
      end
    end
  end

end

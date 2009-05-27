require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserMailer do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  describe "sending an activation request" do
    before(:each) do
      @user = User.generate
      @email = UserMailer.deliver_activation_request(@user)
    end

    it "should deliver an email" do
      ActionMailer::Base.deliveries.size.should == 1
    end

    it "should have been delivered to the correct user" do
      @email.to.should == [@user.email]
    end

    it "should have a subject including 'Account activation request'" do
      @email.subject.should be_include('Account activation request')
    end

    it "should include an activation link" do
      @email.body.should be_include("http://test.host/user/activate/#{@user.activation_code}")
    end
  end

  describe "sending an activation confirmation" do
    before(:each) do
      @user = User.generate
      @email = UserMailer.deliver_activation_confirmation(@user)
    end

    it "should deliver an email" do
      ActionMailer::Base.deliveries.size.should == 1
    end

    it "should have been delivered to the correct user" do
      @email.to.should == [@user.email]
    end

    it "should have a subject including 'Account activation confirmed'" do
      @email.subject.should be_include('Account activation confirmed')
    end

    it "should include a link back to the site" do
      @email.body.should be_include("http://test.host")
    end

  end

  describe "sending a password reset" do
    before(:each) do
      @user = User.generate
      @email = UserMailer.deliver_password_reset(@user)
    end

    it "should deliver an email" do
      ActionMailer::Base.deliveries.size.should == 1
    end

    it "should have been delivered to the correct user" do
      @email.to.should == [@user.email]
    end

    it "should have a subject including password reset" do
      @email.subject.should be_include('Password Reset')
    end

    it "should have include a new password for the user" do
      @email.body.should be_include(@user.password)
    end
  end

  describe "sending a suspension notice" do
    before(:each) do
      @user = User.generate
      @email = UserMailer.deliver_suspension_notice(@user)
    end

    it "should deliver an email" do
      ActionMailer::Base.deliveries.size.should == 1
    end

    it "should have been delivered to the correct user" do
      @email.to.should == [@user.email]
    end

    it "should have a subject including 'Account activation confirmed'" do
      @email.subject.should be_include('Account Suspended')
    end
  end

  describe "sending a deletion notice" do
    before(:each) do
      @user = User.generate
      @email = UserMailer.deliver_deletion_notice(@user)
    end

    it "should deliver an email" do
      ActionMailer::Base.deliveries.size.should == 1
    end

    it "should have been delivered to the correct user" do
      @email.to.should == [@user.email]
    end

    it "should have a subject including 'Account activation confirmed'" do
      @email.subject.should be_include('Account Deleted')
    end
  end
end

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserObserver do
  before(:each) do
    @user = User.generate
    @transition = nil
  end

  describe "after a 'request_activation' transition" do
    before(:each) do
      UserMailer.stub!(:deliver_activation_request)
    end

    it "should deliver an activation email to the user" do
      UserMailer.should_receive(:deliver_activation_request)
      UserObserver.instance.after_request_activation(@user, @transition)
    end
  end

  describe "after an 'activate' transition" do
    before(:each) do
      UserMailer.stub!(:deliver_activation_confirmation)
    end

    it "should deliver an activation confirmation to the user" do
      UserMailer.should_receive(:deliver_activation_confirmation)
      UserObserver.instance.after_activate(@user, @transition)
    end
  end

  describe "after a 'suspend' transition" do
    before(:each) do
      UserMailer.stub!(:deliver_suspension_notice)
    end

    it "should deliver a suspension notice to the user" do
      UserMailer.should_receive(:deliver_suspension_notice)
      UserObserver.instance.after_suspend(@user, @transition)
    end
  end

  describe "after a 'mark_deleted' transition" do
    before(:each) do
      UserMailer.stub!(:deliver_deletion_notice)
    end

    it "should deliver a deletion notice to the user" do
      UserMailer.should_receive(:deliver_deletion_notice)
      UserObserver.instance.after_mark_deleted(@user, @transition)
    end
  end
end

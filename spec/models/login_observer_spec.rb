require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LoginObserver do
  before(:each) do
    @login = Login.generate
    @transition = nil
  end

  describe "after a 'request_activation' transition" do
    before(:each) do
      LoginMailer.stub!(:deliver_activation_request)
    end

    it "should deliver an activation email to the user" do
      LoginMailer.should_receive(:deliver_activation_request)
      LoginObserver.instance.after_request_activation(@login, @transition)
    end
  end

  describe "after an 'activate' transition" do
    before(:each) do
      LoginMailer.stub!(:deliver_activation_confirmation)
    end

    it "should deliver an activation confirmation to the user" do
      LoginMailer.should_receive(:deliver_activation_confirmation)
      LoginObserver.instance.after_activate(@login, @transition)
    end
  end

  describe "after a 'suspend' transition" do
    before(:each) do
      LoginMailer.stub!(:deliver_suspension_notice)
    end

    it "should deliver a suspension notice to the user" do
      LoginMailer.should_receive(:deliver_suspension_notice)
      LoginObserver.instance.after_suspend(@login, @transition)
    end
  end

  describe "after a 'mark_deleted' transition" do
    before(:each) do
      LoginMailer.stub!(:deliver_deletion_notice)
    end

    it "should deliver a deletion notice to the user" do
      LoginMailer.should_receive(:deliver_deletion_notice)
      LoginObserver.instance.after_mark_deleted(@login, @transition)
    end
  end
end

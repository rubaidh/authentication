class LoginObserver < ActiveRecord::Observer
  unloadable

  # mail the user after signing up
  def after_request_activation(login, transition)
    LoginMailer.deliver_activation_request(login)
  end

  # mail the user to confirm activation
  def after_activate(login, transition)
    LoginMailer.deliver_activation_confirmation(login)
  end

  # mail the user to notify they have had their account suspended
  def after_suspend(login, transition)
    LoginMailer.deliver_suspension_notice(login)
  end

  def after_mark_deleted(login, transition)
    LoginMailer.deliver_deletion_notice(login)
  end

end

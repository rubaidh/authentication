class UserObserver < ActiveRecord::Observer
  unloadable

  # mail the user after signing up
  def after_request_activation(user, transition)
    UserMailer.deliver_activation_request(user)
  end

  # mail the user to confirm activation
  def after_activate(user, transition)
    UserMailer.deliver_activation_confirmation(user)
  end

  # mail the user to notify they have had their account suspended
  def after_suspend(user, transition)
    UserMailer.deliver_suspension_notice(user)
  end

  def after_mark_deleted(user, transition)
    UserMailer.deliver_deletion_notice(user)
  end

end

class UserMailer < ActionMailer::Base

  def activation_request(user)
    setup_email(user)
    @subject += "Account activation request"
    @body[:url] = activate_url(user.activation_code)
  end

  def activation_confirmation(user)
    setup_email(user)
    @subject += "Account activation confirmed"
    @body[:url] = root_url
  end

  def password_reset(user)
    setup_email(user)
    @subject += "Password Reset"
    @body[:password] = user.password
    @body[:url] = root_url
  end

  def suspension_notice(user)
    setup_email(user)
    @subject += "Account Suspended"
    @body[:url] = root_url
  end

  def deletion_notice(user)
    setup_email(user)
    @subject += "Account Deleted"
  end

  protected
  def setup_email(user)
    subject    '[website] '
    recipients user.email
    from       "<noreply@#{default_url_options[:host]}>"
    sent_on    Time.now.utc
    body       :user => user
  end

end

class LoginMailer < ActionMailer::Base

  def activation_request(login)
    setup_email(login)
    @subject += "Account activation request"
    @body[:url] = activate_url(login.activation_code)
  end

  def activation_confirmation(login)
    setup_email(login)
    @subject += "Account activation confirmed"
    @body[:url] = root_url
  end

  def password_reset(login)
    setup_email(login)
    @subject += "Password Reset"
    @body[:password] = login.password
    @body[:url] = root_url
  end

  def suspension_notice(login)
    setup_email(login)
    @subject += "Account Suspended"
    @body[:url] = root_url
  end

  def deletion_notice(login)
    setup_email(login)
    @subject += "Account Deleted"
  end

  protected
  def setup_email(login)
    subject    '[website] '
    recipients login.email
    from       "<noreply@#{default_url_options[:host]}>"
    sent_on    Time.now.utc
    body       :login => login
  end

end

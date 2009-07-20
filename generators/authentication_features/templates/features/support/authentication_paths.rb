
## START AUTHENTICATION STEPS
    when /the reset password page/i
      new_password_path

    when /the change password page/i
      edit_password_path

    when /the login page/i
      login_path

    when /the signup page/i
      signup_path

    when /the resend activation page/i
      new_activation_path

    # admin pages
    when /the admin users page/i
      admin_users_path

    when /the admin users inactive page/i
      inactive_admin_users_path
## END AUTHENTICATION STEPS

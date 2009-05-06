Given /^there is a pending login with the email address "(.*)"$/ do |email|
  user = User.spawn do |user|
    user.login = Login.spawn(:user => user, :email => email)
  end
  user.save!
end

Given /^there is a suspended user with the username "(.*)" and password "(.*)"$/ do |username, password|
  user = User.spawn do |user|
    user.login = Login.spawn(:user => user, :username => username, :password => password, :password_confirmation => password)
  end
  user.save!
  user.login.suspend
end

Given /^there is a pending user with the username "(.*)" and password "(.*)"$/ do |username, password|
  user = User.spawn do |user|
    user.login = Login.spawn(:user => user, :username => username, :password => password, :password_confirmation => password)
  end
  user.save!
end

Given /^there is an active user with the username "(.*)" and password "(.*)"$/ do |username, password|
  user = User.spawn do |user|
    user.login = Login.spawn(:user => user, :username => username, :password => password, :password_confirmation => password)
  end
  user.save!
  user.login.activate
end

Given /^there is an active administrator with the username "(.*)" and password "(.*)"$/ do |username, password|
  user = User.spawn do |user|
    user.administrator = true
    user.login = Login.spawn(:user => user, :username => username, :password => password, :password_confirmation => password)
  end
  user.save!
  user.login.activate
end

Given /^there is a pending user with the activation code "(.*)"$/ do |activation_code|
  user = User.spawn do |user|
    user.login = Login.spawn(:user => user)
  end
  user.save!
  user.login.activation_code = activation_code
  user.login.save!
end

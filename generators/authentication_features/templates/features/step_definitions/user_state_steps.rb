Given /^there is a pending login with the email address "(.*)"$/ do |email|
  user = User.generate(:email => email)
end

Given /^there is a suspended user with the email "(.*)" and password "(.*)"$/ do |email, password|
  user = User.generate(:email => email, :password => password, :password_confirmation => password)
  user.suspend
end

Given /^there is a pending user with the email "(.*)" and password "(.*)"$/ do |email, password|
  user = User.generate(:email => email, :password => password, :password_confirmation => password)
end

Given /^there is an active user with the email "(.*)" and password "(.*)"$/ do |email, password|
  user = User.generate(:email => email, :password => password, :password_confirmation => password)
  user.activate
end

Given /^there is an active administrator with the email "(.*)" and password "(.*)"$/ do |email, password|
  user = User.generate(:email => email, :password => password, :password_confirmation => password, :administrator => true)
  user.activate
end

Given /^there is a pending user with the activation code "(.*)"$/ do |activation_code|
  user = User.spawn
  user.activation_code = activation_code
  user.save!
end

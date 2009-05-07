Given /^that I am an anonymous user$/ do
end

Given /^that I am an authenticated user with the username "(.*)" and password "(.*)"$/ do |username, password|
  Given "there is an active user with the username \"#{username}\" and password \"#{password}\""
  When "I go to the login page"
  When "I fill in \"username\" with \"#{username}\""
  When "I fill in \"password\" with \"#{password}\""
  When "I press \"login_button\""
  Then "I should see \"Successfully logged in\""
end

Given /^that I am an authenticated admin user with username "(.*)" and password "(.*)"$/ do |username, password|
  Given "there is an active administrator with the username \"#{username}\" and password \"#{password}\""
  When "I go to the login page"
  When "I fill in \"username\" with \"#{username}\""
  When "I fill in \"password\" with \"#{password}\""
  When "I press \"login_button\""
  Then "I should see \"Successfully logged in\""
end


Given /^I have an email address "(.*)"$/ do |email|
  Login.generate!(:email => email)
end

When /^I fill in the signup form with "(.*)", "(.*)", "(.*)", "(.*)", "(.*)", "(.*)"$/ do |first_name, last_name, username, email, password, password_confirmation|
  When "I fill in \"user_first_name\" with \"#{first_name}\""
  When "I fill in \"user_last_name\" with \"#{last_name}\""
  When "I fill in \"user_login_attributes_username\" with \"#{username}\""
  When "I fill in \"user_login_attributes_email\" with \"#{email}\""
  When "I fill in \"user_login_attributes_password\" with \"#{password}\""
  When "I fill in \"user_login_attributes_password_confirmation\" with \"#{password_confirmation}\""
end

When /^I activate a user with activation code "(.*)"$/ do |activation_code|
  visit activate_url(activation_code)
end

Then /^I should push the "(.*)" button and be given a forbidden exception$/ do |button_name|
  lambda { click_button(button_name) }.should raise_error(ActionController::Forbidden)
end

Then /^I should be redirected to (.*)$/ do |text|
  request.request_uri.should == (path_to(text))
end

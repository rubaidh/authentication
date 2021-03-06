Given /^that I am an anonymous user$/ do
end

Given /^that I am an authenticated user with the email "(.*)" and password "(.*)"$/ do |email, password|
  Given "there is an active user with the email \"#{email}\" and password \"#{password}\""
  When "I go to the login page"
  When "I fill in \"email\" with \"#{email}\""
  When "I fill in \"password\" with \"#{password}\""
  When "I press \"login_button\""
  Then "I should see \"Successfully logged in\""
end

Given /^that I am an authenticated admin user with email "(.*)" and password "(.*)"$/ do |email, password|
  Given "there is an active administrator with the email \"#{email}\" and password \"#{password}\""
  When "I go to the login page"
  When "I fill in \"email\" with \"#{email}\""
  When "I fill in \"password\" with \"#{password}\""
  When "I press \"login_button\""
  Then "I should see \"Successfully logged in\""
end

Given /^there are no users in the database$/ do
  User.delete_all
end

Given /^I have an email address "(.*)"$/ do |email|
  User.generate!(:email => email)
end

When /^I fill in the signup form with "(.*)", "(.*)", "(.*)", "(.*)", "(.*)"$/ do |first_name, last_name, email, password, password_confirmation|
  When "I fill in \"user_first_name\" with \"#{first_name}\""
  When "I fill in \"user_last_name\" with \"#{last_name}\""
  When "I fill in \"user_email\" with \"#{email}\""
  When "I fill in \"user_password\" with \"#{password}\""
  When "I fill in \"user_password_confirmation\" with \"#{password_confirmation}\""
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

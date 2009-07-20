Feature: Allow users to change their own passwords
  As an authenticated user
  I want be able to change my password
  So that the website support doesn't need to deal with this issue

Scenario: I am not logged in and shouldn't be able to change a password in this manner
  Given that I am an anonymous user
  When I go to the change password page
  Then I should be redirected to the login page

  Scenario: I am a logged in user wanting to change my password
    Given that I am an authenticated user with the email "foobar@foo.bar" and password "password"
    When I go to the change password page
    Then I should see "Editing Password"

  Scenario: Changing my password with a new valid password and confirmation
    Given that I am an authenticated user with the email "foobar@foo.bar" and password "password"
    When I go to the change password page
    And I fill in "password" with "omgwtfpwnt!"
    And I fill in "password_confirmation" with "omgwtfpwnt!"
    And I press "update_button"
    Then I should see "Password was successfully updated."

  Scenario: Changing my password with invalid input
    Given that I am an authenticated user with the email "foobar@foo.bar" and password "password"
    When I go to the change password page
    And I fill in "password" with "omgwtfpwnt!"
    And I fill in "password_confirmation" with "omgBBQFIREFIREFIRE"
    And I press "update_button"
    Then I should see "Editing Password"

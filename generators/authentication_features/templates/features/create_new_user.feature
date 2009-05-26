Feature: Creating a new user
  As an anonymous user
  I want to be able to create a new user in the application
  So that I can do all the awesome stuff that the developers have implemented in the authenticated realm of the app

  Scenario: Filling in the form with unique valid data
    Given that I am an anonymous user
    When I go to the signup page
    And I fill in the signup form with "Joe", "Bloggs", "valid.email@rubaidh.com", "foobar", "foobar"
    And I press "user_submit"
    Then I should see "Your account has been created, an activation email will shortly be delivered to the email address you provided."

  Scenario: attempting to create an account where the username already taken
    Given that I am an anonymous user
    And there is an active user with the email "valid.email@rubaidh.com" and password "foobar"
    When I go to the signup page
    And I fill in the signup form with "Joe", "Bloggs", "valid.email@rubaidh.com", "foobar", "foobar"
    And I press "user_submit"
    Then I should see "Login username has already been taken"

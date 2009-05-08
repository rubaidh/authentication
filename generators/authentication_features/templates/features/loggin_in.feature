Feature: Logging into the application
  As a user who isn't logged in
  I want be able to log in to the application
  So that I can check out all the cool stuff one of the developers has implemented for me to use

  Scenario: Anonymous user without an account attempting to log in
    Given that I am an anonymous user
    When I go to the login page
    When I fill in "username" with "barney"
    When I fill in "password" with "foobar"
    When I press "login_button"
    Then I should see "Could not log in with that username and password combination"

  Scenario: Anonymous user with an active account attempting to log in
    Given that I am an anonymous user
    And there is an active user with the username "chocolate" and password "chip"
    When I go to the login page
    When I fill in "username" with "chocolate"
    When I fill in "password" with "chip"
    When I press "login_button"
    Then I should see "Successfully logged in"

    Scenario: Attempting to login into /admin/users as the first user
      Given that I am an anonymous user
      And there are no users in the database
      And there is an active user with the username "chocolate" and password "chip"
      When I go to the admin users page
      When I fill in "username" with "chocolate"
      When I fill in "password" with "chip"
      When I press "login_button"
      Then I should see "Successfully logged in"
      And I should see "Listing Active Users"

  Scenario: Attempting to login into /admin/users as a non-admin user
    Given that I am an anonymous user
    And there is an active user with the username "foo" and password "bar"
    And there is an active user with the username "chocolate" and password "chip"
    When I go to the admin users page
    When I fill in "username" with "chocolate"
    When I fill in "password" with "chip"
    Then I should push the "login_button" button and be given a forbidden exception

  Scenario: Logging into /admin/users as an admin user
    Given that I am an anonymous user
    And there is an active administrator with the username "button" and password "bean"
    When I go to the admin users page
    When I fill in "username" with "button"
    When I fill in "password" with "bean"
    When I press "login_button"
    Then I should see "Successfully logged in"
    And I should see "Listing Active Users"

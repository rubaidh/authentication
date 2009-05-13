Feature: Adminstrate users
  As an administrator user
  I want to be able to admin the users and their logins
  So that in the event of needing to intervene I can do so

  Scenario: Listing the users in the application
    Given that I am an authenticated admin user with username "admin" and password "pass"
    When I go to the admin users page
    Then I should see "Listing Active Users"
    And I should see "admin"

  Scenario: Click on a user in the list
    Given that I am an authenticated admin user with username "admin" and password "pass"
    When I go to the admin users page
    And I follow "admin"
    Then I should see "admin"
    And  I should see "Edit User"

  Scenario: Editing a user
    Given that I am an authenticated admin user with username "admin" and password "pass"
    When I go to the admin users page
    And I follow "admin"
    And I follow "Edit User"
    And I fill in "user_first_name" with "Pizzaface"
    And I press "user_submit"
    Then I should see "User successfully updated"
    And I should see "First name: Pizzaface"

  Scenario: Trying to delete yourself and failing
    Given that I am an authenticated admin user with username "admin" and password "pass"
    When I go to the admin users page
    And I follow "admin"
    And I follow "Delete User"
    Then I should see "admin"
    And I should see "You cannot delete yourself."

  Scenario: Deleting a user that isn't yourself
    Given that I am an authenticated admin user with username "admin" and password "pass"
    And there is an active user with the username "bob_monkhouse" and password "legend"
    When I go to the admin users page
    And I follow "bob_monkhouse"
    And I follow "Delete User"
    Then I should see "Listing Active Users"
    And I should see "User successfully deleted"

  Scenario: Activating a user
    Given that I am an authenticated admin user with username "admin" and password "pass"
    And there is a pending user with the username "peter" and password "griffen"
    When I go to the admin users inactive page
    And I follow "peter"
    And I follow "Activate User"
    Then I should see "User has been activated"
    And I should see "peter"

  Scenario: Attempting to activate an active user
    Given that I am an authenticated admin user with username "admin" and password "pass"
    And there is an active user with the username "megaman" and password "pewpew"
    When I go to the admin users page
    And I follow "megaman"
    And I follow "Activate User"
    Then I should see "User is already active"
    And I should see "megaman"

   Scenario: Suspending a naughty user
     Given that I am an authenticated admin user with username "admin" and password "pass"
     And there is an active user with the username "adam_west" and password "iambatman"
     When I go to the admin users page
     And I follow "adam_west"
     And I follow "Suspend User"
     Then I should see "User has been suspended"
     And I should see "adam_west"

   Scenario: Attempting to suspend a suspended user
     Given that I am an authenticated admin user with username "admin" and password "pass"
     And there is a suspended user with the username "adam_west" and password "iambatman"
     When I go to the admin users inactive page
     And I follow "adam_west"
     And I follow "Suspend User"
     Then I should see "User is already suspended"
     And I should see "adam_west"

  Scenario: Attempting to suspend myself because I'm a bit stupid like that
    Given that I am an authenticated admin user with username "admin" and password "pass"
    When I go to the admin users page
    And I follow "admin"
    And I follow "Suspend User"
    Then I should see "You cannot suspend yourself"
    And I should see "admin"

  Scenario: Resetting a users password
    Given that I am an authenticated admin user with username "admin" and password "pass"
    And there is a suspended user with the username "michael" and password "palin"
    When I go to the admin users inactive page
    And I follow "michael"
    And I follow "Reset Password"
    Then I should see "Password reset sent"
    And I should see "michael"

  Scenario: Setting an active user as an administrator
    Given that I am an authenticated admin user with username "admin" and password "pass"
    And there is an active user with the username "Tony" and password "Montana"
    When I go to the admin users page
    And I follow "Tony"
    And I follow "Make Administrator"
    Then I should see "User administrator permissions updated"
    And I should see "Tony"

  Scenario: Removing administrator rights from a user
    Given that I am an authenticated admin user with username "admin" and password "pass"
    And there is an active administrator with the username "cookie" and password "monster"
    When I go to the admin users page
    And I follow "cookie"
    And I follow "Revoke Administrator"
    Then I should see "User administrator permissions updated"
    And I should see "cookie"

  Scenario: Attempting to remove administrator rights from myself
    Given that I am an authenticated admin user with username "admin" and password "pass"
    When I go to the admin users page
    And I follow "admin"
    And I follow "Revoke Administrator"
    Then I should see "I'm sorry Dave, I can't let you do that!"
    And I should see "admin"

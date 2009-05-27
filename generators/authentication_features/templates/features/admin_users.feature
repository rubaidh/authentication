Feature: Adminstrate users
  As an administrator user
  I want to be able to admin the users and their logins
  So that in the event of needing to intervene I can do so

  Scenario: Listing the users in the application
    Given that I am an authenticated admin user with email "admin@email.com" and password "pass"
    When I go to the admin users page
    Then I should see "Listing Active Users"
    And I should see "admin@email.com"

  Scenario: Click on a user in the list
    Given that I am an authenticated admin user with email "admin@email.com" and password "pass"
    When I go to the admin users page
    And I follow "admin@email.com"
    Then I should see "admin@email.com"
    And  I should see "Edit User"

  Scenario: Editing a user
    Given that I am an authenticated admin user with email "admin@email.com" and password "pass"
    When I go to the admin users page
    And I follow "admin@email.com"
    And I follow "Edit User"
    And I fill in "user_first_name" with "Pizzaface"
    And I press "user_submit"
    Then I should see "User successfully updated"
    And I should see "First name: Pizzaface"

  Scenario: Trying to delete yourself and failing
    Given that I am an authenticated admin user with email "admin@email.com" and password "pass"
    When I go to the admin users page
    And I follow "admin@email.com"
    And I follow "Delete User"
    Then I should see "admin@email.com"
    And I should see "You cannot delete yourself."

  Scenario: Deleting a user that isn't yourself
    Given that I am an authenticated admin user with email "admin@email.com" and password "pass"
    And there is an active user with the email "bob_monkhouse@something.com" and password "legend"
    When I go to the admin users page
    And I follow "bob_monkhouse@something.com"
    And I follow "Delete User"
    Then I should see "Listing Active Users"
    And I should see "User successfully deleted"

  Scenario: Activating a user
    Given that I am an authenticated admin user with email "admin@email.com" and password "pass"
    And there is a pending user with the email "peter@nehnehneh.neh" and password "griffen"
    When I go to the admin users inactive page
    And I follow "peter@nehnehneh.neh"
    And I follow "Activate User"
    Then I should see "User has been activated"
    And I should see "peter@nehnehneh.neh"

  Scenario: Attempting to activate an active user
    Given that I am an authenticated admin user with email "admin@email.com" and password "pass"
    And there is an active user with the email "megaman@someth.in" and password "pewpew"
    When I go to the admin users page
    And I follow "megaman@someth.in"
    And I follow "Activate User"
    Then I should see "User is already active"
    And I should see "megaman@someth.in"

   Scenario: Suspending a naughty user
     Given that I am an authenticated admin user with email "admin@email.com" and password "pass"
     And there is an active user with the email "adam_west@nanananana-batman.com" and password "iambatman"
     When I go to the admin users page
     And I follow "adam_west@nanananana-batman.com"
     And I follow "Suspend User"
     Then I should see "User has been suspended"
     And I should see "adam_west@nanananana-batman.com"

   Scenario: Attempting to suspend a suspended user
     Given that I am an authenticated admin user with email "admin@email.com" and password "pass"
     And there is a suspended user with the email "adam_west@nanananana-batman.com" and password "iambatman"
     When I go to the admin users inactive page
     And I follow "adam_west@nanananana-batman.com"
     And I follow "Suspend User"
     Then I should see "User is already suspended"
     And I should see "adam_west@nanananana-batman.com"

  Scenario: Attempting to suspend myself because I'm a bit stupid like that
    Given that I am an authenticated admin user with email "admin@email.com" and password "pass"
    When I go to the admin users page
    And I follow "admin@email.com"
    And I follow "Suspend User"
    Then I should see "You cannot suspend yourself"
    And I should see "admin"

  Scenario: Resetting a users password
    Given that I am an authenticated admin user with email "admin@email.com" and password "pass"
    And there is a suspended user with the email "michael@pal.in" and password "palin"
    When I go to the admin users inactive page
    And I follow "michael@pal.in"
    And I follow "Reset Password"
    Then I should see "Password reset sent"
    And I should see "michael@pal.in"

  Scenario: Setting an active user as an administrator
    Given that I am an authenticated admin user with email "admin@email.com" and password "pass"
    And there is an active user with the email "Tony@monta.na" and password "Montana"
    When I go to the admin users page
    And I follow "Tony@monta.na"
    And I follow "Make Administrator"
    Then I should see "User administrator permissions updated"
    And I should see "Tony@monta.na"

  Scenario: Removing administrator rights from a user
    Given that I am an authenticated admin user with email "admin@email.com" and password "pass"
    And there is an active administrator with the email "cookie@email.com" and password "monster"
    When I go to the admin users page
    And I follow "cookie@email.com"
    And I follow "Revoke Administrator"
    Then I should see "User administrator permissions updated"
    And I should see "cookie@email.com"

  Scenario: Attempting to remove administrator rights from myself
    Given that I am an authenticated admin user with email "admin@email.com" and password "pass"
    When I go to the admin users page
    And I follow "admin@email.com"
    And I follow "Revoke Administrator"
    Then I should see "I'm sorry Dave, I can't let you do that!"
    And I should see "admin"

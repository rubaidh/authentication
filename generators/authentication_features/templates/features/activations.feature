Feature: Allow a user to activate their account
  As an anonymous user
  I want to be able to activate my account
  So that a site moderator doesn't have to do it and I can prove that I am less likely to be a spambot

  Scenario: Resetting a password for a valid account that is pending
    Given that I am an anonymous user
    And there is a pending login with the email address "valid.email@rubaidh.com"
    When I go to the resend activation page
    And I fill in "email" with "valid.email@rubaidh.com"
    And I press "email_submit"
    Then I should see "Your activation email has been resent"

  Scenario: Attempting to reset a password for a valid account but using the wrong email address
    Given that I am an anonymous user
    And there is a pending login with the email address "valid.email@rubaidh.com"
    When I go to the resend activation page
    And I fill in "email" with "email.invalid@rubaidh.com"
    And I press "email_submit"
    Then I should see "The email address you specified does not have a pending account associated with it"

  Scenario: I have received an activation email and I follow the link inside
    Given that I am an anonymous user
    And there is a pending user with the activation code "activation_code_123"
    When I activate a user with activation code "activation_code_123"
    Then I should see "Account successfully activated, thank you"

  Scenario: I have no activation email but I want to try and activate anyway
    Given that I am an anonymous user
    When I activate a user with activation code "activation_code_123"
    Then I should see "There was an error activating your account"

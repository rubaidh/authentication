Feature: Reset Password for a login
  As a user who has forgotten their password
  I want to be able to reset my password using my email address
  So that I can quickly reset my password without having to contact technical support

  Scenario: My account has the email address valid.email[at]rubaidh.com but I have forgotten my password
    Given that I am an anonymous user
    And I have an email address "valid.email@rubaidh.com"
    When I go to the reset password page
    And I fill in "email" with "valid.email@rubaidh.com"
    And I press "email_submit"
    Then I should see "A new password has been emailed to you."

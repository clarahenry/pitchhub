Feature: new user registration
  As an unregistered user, I want to join so that I may use the system

  Background:
    When I go to the new user registration page
    And I fill in the new user form
    And I submit the form
    Then I should be on the getting started page
    Then I should see the 'getting started' contents

  Scenario: new user goes through the setup wizard
    When I fill in the following:
      | first_name | O             |
    And I follow "awesome_button"
    And I confirm the alert
    Then I should be on the stream page

  Scenario: new user tries to XSS itself
    When I fill in the following:
      | first_name | <script>alert(0)// |
    And I focus the "location" field
    Then I should see a flash message containing "Hey, <script>alert(0)//!"

  Scenario: new user does not add any tags in setup wizard and cancel the alert
    When I fill in the following:
      | first_name | some name     |
    And I focus the "location" field
    Then I should see a flash message containing "Hey, some name!"
    When I follow "awesome_button"
    And I reject the alert
    Then I should be on the getting started page
    And I should see a flash message containing "All right, I’ll wait."

  Scenario: new user skips the setup wizard
    When I follow "awesome_button"
    And I confirm the alert
    Then I should be on the stream page

  Scenario: user fills in bogus data - client side validation
    When I log out manually
    And I go to the new user registration page
    And I fill in the following:
      | user_username        | $%&(/&%$&/=)(/    |
    And I press "Join"
    Then I should not be able to join
    And I should have a validation error on "user_username, user_password, user_email"

    When I fill in the following:
      | user_username     | valid_user                        |
      | user_email        | this is not a valid email $%&/()( |
    And I press "Join"
    Then I should not be able to join
    And I should have a validation error on "user_password, user_email"

    When I fill in the following:
      | user_email        | valid@email.com        |
      | user_password     | 1                      |
    And I press "Join"
    Then I should not be able to join
    And I should have a validation error on "user_password, user_password_confirmation"
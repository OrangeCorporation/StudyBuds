Feature: Create a group

@create-a-group
Scenario: Group creation
    Given I do the login as "10" "10"
    And I go to the "group creation" page
    When I fill out the "group name" with "amirparsa"
    And I fill out the "description" with "A group for capstone project collaboration"
    And I fill out the "member limit" with "23"
    And I fill out the "telegram group link" with "https://t.me/amirparsa"
    And I select the "MACHINE LEARNING" course
    And I set the group type as "private"
    And I click the create button
    Then The system creates the group successfully and displays a confirmation message
    And I go to the "profile" page
    And I do the logout

@create-a-group
Scenario: Validation for required fields
    Given I do the login as "10" "10"
    And I go to the "group creation" page
    When The student attempts to create a group without filling in one or more required fields
    Then The system displays an error message prompting the student to complete all required fields
    And I go to the "profile" page
    And I do the logout

@create-a-group
Scenario: Telegram account is not linked
    Given I do the login as "10" "10"
    And I go to the "profile" page
    And A telegram account has not been linked
    And I go to the "group creation" page
    Then An error message appears to ask the user to link a Telegram account
    And I go to the "profile" page
    And I do the logout

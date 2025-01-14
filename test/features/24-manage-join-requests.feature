Feature: Manage join requests

@manage-join-requests
Scenario: See join request
    Given I do the login as "10" "10"
    And I am a SuperStudent of a group
    And a student sends a join request to that group
    When I go to the "notifications" page
    Then I see the notification with id "1" with the "Nona has requested to join the Capstone project" message
    And I go to the "profile" page
    And I do the logout

@manage-join-requests
Scenario: Accept join request
    Given I do the login as "10" "10"
    And I am a SuperStudent of a group
    And a student sends a join request to that group
    When I go to the "notifications" page
    And I open the notification with id "1"
    And I click accept
    Then The user receives the invitation link of Telegram group
    And a notification is sent to him
    And I go to the "profile" page
    And I do the logout

@manage-join-requests
Scenario: Refuse join request
    Given I do the login as "10" "10"
    And I am a SuperStudent of a group
    And a student sends a join request to that group
    When I go to the "notifications" page
    And I open the notification with id "1"
    And I click refuse
    Then The user does not receive the invitation link of Telegram group
    And a notification is sent to him about the refusal
    And I go to the "profile" page
    And I do the logout


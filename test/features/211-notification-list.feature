Feature: Notification List

@notification-list
Scenario: Mark a notification as accepted
    Given I do the login as "10" "10"
    And I go to the "notifications" page    
    And I open the notification with id "1"
    And I click "accept"
    Then The notification background becomes gray
    And The button to show details for notification with id "1" is removed
    And The notification with id "1" has "accepted" as its label
    And I go to the "profile" page
    And I do the logout

@notification-list
Scenario: Mark a notification as rejected
    Given I do the login as "10" "10"
    And I go to the "notifications" page
    And I open the notification with id "1"
    And I click "reject"
    Then The notification background becomes gray
    And The button to show details for notification with id "1" is removed
    And The notification with id "1" has "rejected" as its label
    And I go to the "profile" page
    And I do the logout
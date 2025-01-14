Feature: Joined group list

@joined-group-list
Scenario: View All Groups
    Given I do the login as "10" "10"
    When I navigate to the "Joined group" tab
    Then I see a list of all groups I am part of
    And I go to the "profile" page
    And I do the logout

@joined-group-list
Scenario: Empty State When No Groups Exist
    Given I do the login as "10" "10"
    When I navigate to the "Joined group" tab
    Then a message appears telling "No groups found."
    And I go to the "profile" page
    And I do the logout

@joined-group-list
Scenario: Highlight Groups I Own
    Given I do the login as "10" "10"
    When I navigate to the "Owned group" tab
    Then The groups I own are there
    And I go to the "profile" page
    And I do the logout

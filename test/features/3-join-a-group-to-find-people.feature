Feature: Join a group to find people

@join-a-group-to-find-people
Scenario: Duplicate join request
    Given I do the login as "10" "10"
    And I go to the "search" page
    And I type "aya" in the search bar                                
    And I already have sent a join request to the group
    When I attempt to send another join request
    Then The "pending" button is displayed to indicate that a request is already pending
    And I go to the "profile" page
    And I do the logout

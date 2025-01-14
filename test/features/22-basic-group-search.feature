Feature: Basic group search

@basic-group-search
Scenario: Search for some groups
    Given I do the login as "10" "10"
    When I go to the "search" page
    When I type "adm" in the search bar (case-insensitive)
    Then I see all groups where "adm" is inside their group name
    And I go to the "profile" page
    And I do the logout

@basic-group-search
Scenario: Search returns no results
    Given I do the login as "10" "10"
    When I go to the "search" page
    When I type "orange" in the search bar (case-insensitive)
    And no groups contain "orange" in their name
    Then the system displays an empty list
    And a message appears telling "No results found"
    And I go to the "profile" page
    And I do the logout

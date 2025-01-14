Feature: Profile

@profile
Scenario: Profile
    Given I do the login as "10" "10"
    When I go to the "profile" page
    Then I see my "studentId" "10"
    And I see my "fullname" "Noah White"
    And I see my "telegramId" "36"
    And I do the logout

@profile
Scenario: Telegram Id
    Given I do the login as "10" "10"
    When I go to the "profile" page
    And I fill out the "telegramId" with "77"
    Then I see my "telegramId" "77"
    And I do the logout

@profile
Scenario: Profile Information is Not Editable
    Given I do the login as "10" "10"
    When I go to the "profile" page
    Then all fields are locked or disabled from editing except the telegramId
    And I do the logout

Feature: Persist login data

Scenario: Login persisted
Given I do the login as "10" "10"
When I "close" the application
And I "open" the application
Then The login screen is skipped
And I am on the joined groups screen
And I go to the "profile" page
And I do the logout

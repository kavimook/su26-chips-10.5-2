Feature: Bills
  As a user
  I want to reach the Bills page from the navigation bar
  So that I can look up legislation

  Scenario: Reaching the Bills page from the navbar
    Given I am on the homepage
    When I follow "Bills"
    Then I should see "Bills"
    And I should be on the bills page
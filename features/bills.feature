Feature: Bills
  As a user
  I want to reach the Bills page from the navigation bar
  So that I can look up legislation

  Scenario: Reaching the Bills page from the navbar
    Given I am on the homepage
    When I follow "Bills"
    Then I should see "Search congress.gov"
    And I should be on the bills page

  Scenario: Search results are shown in a formatted table
    Given I am on the bills page
    Then I should see "HR 3076"
    And I should see "Became Public Law No: 117-108 on Apr 6, 2024"
    And I should see "Showing 1 of 25000 results"
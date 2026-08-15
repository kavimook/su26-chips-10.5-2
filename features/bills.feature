Feature: Bills
  As a user
  I want to reach the Bills page from the navigation bar
  So that I can look up legislation

  Scenario: Reaching the Bills page from the navbar
    Given I am on the homepage
    When I follow "Bills"
    Then I should see "Bills"
    And I should be on the bills page

  Scenario: Searching with no filters shows the most recent bills
    Given congress.gov has recent bills including "A Brand New Bill"
    When I am on the bills page
    Then I should see "A Brand New Bill"

  Scenario: Searching by congress and bill type shows filtered results
    Given congress.gov has a bill "A Filtered Senate Bill" for congress "119" type "s"
    When I am on the bills page
    And I fill in "Congress" with "119"
    And I select "S" from "Bill Type"
    And I press "Search"
    Then I should see "A Filtered Senate Bill"

  Scenario: Searching by bill type without a congress number shows a validation message
    When I am on the bills page
    And I select "S" from "Bill Type"
    And I press "Search"
    Then I should see "Please provide a Congress number"

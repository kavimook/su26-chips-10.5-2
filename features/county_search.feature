Feature: Searching for representatives via the county map

  Scenario: Visiting a county's search URL shows its representatives
    Given a state "Kansas" with symbol "KS" exists
    And a county "Barton County" exists in "Kansas"
    And Geocodio returns "Tracey Mann" as a representative for that search
    When I visit the search page for "Barton County, KS"
    Then I should see "Tracey Mann" in the representatives table
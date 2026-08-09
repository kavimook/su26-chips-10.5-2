Feature: County Map and Representative Search
  As a user
  I want to be able to click on a county in the state map
  So that I can see the representatives for that county

  Scenario: Searching for a county directly via URL returns results
    # This bypasses the map click and directly tests the controller/view flow
    Given I visit the search page for "Alameda County, CA"
    Then I should see representatives for "Alameda County"

  @javascript
  Scenario: The state map renders clickable counties
    # This tests the front-end D3 map rendering
    Given I visit the state map page for "CA"    
    Then the map should have a clickable element for "Alameda County"
Feature: County Map and Representative Search
  As a user
  I want to be able to click on a county in the state map
  So that I can see the senators for that county
  And click on another county
  And make sure that the 2 senators are the same for both counties

  Scenario: Kern County shows California's two Senators
    # California's Senators represent the whole state, so they should appear no matter which CA county the search resolves to.
    Given the Civic API returns Kern County officials for "1120 Truxtun Ave, Bakersfield, CA 93301"
    When I visit the search page for "1120 Truxtun Ave, Bakersfield, CA 93301"
    Then I should see senators for "Alejandro Padilla"
    And I should see senators for "Adam Schiff"

  Scenario: Santa Clara County shows the same two Senators
    Given the Civic API returns Santa Clara County officials for "70 W Hedding St, San Jose, CA 95110"
    When I visit the search page for "70 W Hedding St, San Jose, CA 95110"
    Then I should see senators for "Alejandro Padilla"
    And I should see senators for "Adam Schiff"
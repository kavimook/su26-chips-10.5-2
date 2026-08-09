Feature: Representative Profile Page

  As a voter researching my representatives
  I want to view a representative's full profile
  So that I can see their contact info, party, and photo before reaching out

  Scenario: Viewing a representative with a complete profile
    Given a representative named "Jane Doe" exists with a full profile
    When I visit the profile page for "Jane Doe"
    Then I should see "Jane Doe"
    And I should see "Democrat"
    And I should see "555-1234"
    And I should see "https://doe.house.gov"
    And I should see a photo for the representative

  Scenario: Viewing a representative with missing profile fields
    Given a representative named "Sam Smith" exists with only a name and title
    When I visit the profile page for "Sam Smith"
    Then I should see "Sam Smith"
    And I should see "No Photo Available"
    And I should not see "Phone:"
    And I should not see "Website:"
    And I should not see "Social:"

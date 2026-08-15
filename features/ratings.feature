Feature: Rating news articles
  As a signed-in user
  I want to rate a news article
  So that others can see how useful it is

  Scenario: Rating an article updates its average
    Given a representative with news articles exists
    And I am logged in
    When I visit the news article page for that representative
    And I select "4" from "Your rating"
    And I press "Rate"
    Then I should see "4.0 / 5 (1 rating)"

Feature: Hangman gameplay
  As a player
  I want to interact with the game
  So I can enjoy and test its features

  Scenario: Start a new game
    Given I open the homepage
    Then I should see "Hangman Game"

  Scenario: Guessing a correct letter
    Given I open the homepage
    When I submit the letter "a"
    Then I should see "a"

  Scenario: Losing the game
    Given I open the homepage
    When I submit 6 wrong letters
Then I should see "💀 You lost!"

  Scenario: Toggle dark mode
    Given I open the homepage
    When I click the "🌓 Toggle Light/Dark Mode" button
    Then the background should change

  Scenario: Using the Hint button
    Given I open the homepage
    When I click the "💡 Hint" button
    Then I should see a helpful clue

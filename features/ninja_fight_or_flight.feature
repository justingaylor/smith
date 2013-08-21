Feature: Fight or flight
  As a ninja commander,
  I want my ninjas to decide whether to take on an
  opponent based on their skill levels,
  In order to increase the ninja survival rate.

  Scenario: Weaker opponent
    Given the ninja has a third level black-belt
    When attacked by a samurai
    Then the ninja should engage the opponent

  Scenario: Stronger opponent
    Given the ninja has a third level black-belt
    When attacked by Chuck Norris
    Then the ninja should run for his life
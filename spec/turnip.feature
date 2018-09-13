Feature: Turnip test cases

  Scenario: Pass case
    When something
    Then it passes

  Scenario: Pending case
    When something
    Then it is pending

  Scenario: Failure case
    When something
    Then it fails

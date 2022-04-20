Feature: Report Overview

  Example: A passing example
    Given a report has been generated
    Then the reports directory is created
    And a file named "overview.html" is present

  Example: The page displays the heading Report Overview
    Given a report has been generated
    When I visit the page: "/overview.html"
    Then the report has the heading "Report Overview"

  Example: The Summary table displays the correct columns
    Given a report has been generated
    When I visit the page: "/overview.html"
    Then the Report table has the correct column names

  Example: The correct number of spec groups links are displayed
    Given a report has been generated
    When I visit the page: "/overview.html"
    Then the Spec group table has 7 links to other pages

  Example: Each spec group name is displayed
    Given a report has been generated
    When I visit the page: "/overview.html"
    Then the correct Group name for each spec is displayed

  Example: The correct results are displayed in the summary table
    Given a report has been generated
    When I visit the page: "/overview.html"
    Then the the correct results for each group are displayed in the summary table

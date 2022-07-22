Feature: Example Test - Failing

  Example: The reports directory and HTML file are generated
    Given a report has been generated
    Then the reports directory is created
    And a file named "example-test.html" is present

  Example: The page displays the link: Back to report overview
    Given a report has been generated
    When I visit the page: "/example-test.html"
    Then the report has the link "Back to report overview"

  Example: The Summary table displays the correct columns
    Given a report has been generated
    When I visit the page: "/example-test.html"
    Then the Report table has the correct column names

  Example: The Report table displays the correct results
    Given a report has been generated
    When I visit the page: "/example-test.html"
    Then the example group in the Report table displays the "failed" results

  Example: The Example table displays the correct columns
    Given a report has been generated
    When I visit the page: "/example-test.html"
    Then the example table has the correct columns

  Example: The title displayed in the example table is correct
    Given a report has been generated
    When I visit the page: "/example-test.html"
    Then the title in the example table is "ExampleTest → fails"

  Example: The failure message is displayed in the example
    Given a report has been generated
    When I visit the page: "/example-test.html"
    Then "supposed to fail" is highlighted error message in the example

  Example: The failed code block is highlighted in the example
    Given a report has been generated
    When I visit the page: "/example-test.html"
    Then the failing code highlighted for the example is:
    """
    6
    7
    8
    9
      it 'fails' do
    --->    raise 'supposed to fail'
      end
    end
    """

  Example: The status of the example is failed in the example table
    Given a report has been generated
    When I visit the page: "/example-test.html"
    Then the status of the example is "failed" in the example table

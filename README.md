# RSpec Pretty HTML Reporter

Produce pretty [RSpec](http://rspec.info/) reports.

This is a custom reporter for RSpec which generates pretty HTML reports showing the results of rspec tests. It has
features to embed images and videos into the report providing better debugging information when a test fails.

<img src="https://github.com/TheSpartan1980/rspec_pretty_html_reporter/blob/feature/improve-html-report/images/group_overview_report.png" width="60%"/>

## Setup

Add this in your Gemfile:

```rb
gem 'rspec-pretty-html-reporter'
```

## Running

Either add below in your `.rspec` file

```rb
--format RspecPrettyHtmlReporter
```

or run RSpec with `--format RspecHtmlReporter` like below:

```bash
REPORT_PATH=reports/$(date +%s) bundle exec rspec --format RspecHtmlReporter spec
```

Above will create reports in `reports` directory.

## Usage

Images and videos can be embed by adding their path into example's metadata. Check
this [Sample Test](./spec/embed_graphics_spec.rb).

## Credits

This library is forked from [kingsleyh/rspec_reports_formatter](https://github.com/kingsleyh/rspec_reports_formatter).
Original Credits goes to *[kingsleyh](https://github.com/kingsleyh)*

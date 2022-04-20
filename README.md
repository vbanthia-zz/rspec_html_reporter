[![Gem Version](https://badge.fury.io/rb/rspec_pretty_html_reporter.svg)](https://badge.fury.io/rb/rspec_pretty_html_reporter) 
[![CI](https://github.com/TheSpartan1980/rspec_pretty_html_reporter/actions/workflows/ci.yml/badge.svg)](https://github.com/TheSpartan1980/rspec_pretty_html_reporter/actions/workflows/ci.yml)

# RSpec Pretty HTML Reporter

Produce pretty [RSpec](http://rspec.info/) reports.

This is a custom reporter for RSpec which generates pretty HTML reports showing the results of rspec tests. It has
features to embed images and videos into the report providing better debugging information when a test fails.

<img src="https://github.com/TheSpartan1980/rspec_pretty_html_reporter/blob/master/images/report_overview.png" width="50%"/>
<img src="https://github.com/TheSpartan1980/rspec_pretty_html_reporter/blob/master/images/failing_example.png" width="50%"/>
<img src="https://github.com/TheSpartan1980/rspec_pretty_html_reporter/blob/master/images/passing_example.png" width="50%"/>
<img src="https://github.com/TheSpartan1980/rspec_pretty_html_reporter/blob/master/images/pending_example.png" width="50%"/>

## Setup

Add this to your Gemfile:

```rb
gem 'rspec_pretty_html_reporter'
```

## Generating the report

Either add the below into your `.rspec` file

```rb
--format RspecPrettyHtmlReporter
```

or run RSpec with `--format RspecPrettyHtmlReporter` like below:

```bash
REPORT_PATH=reports/$(date +%s) bundle exec rspec --format RspecPrettyHtmlReporter spec
```

This will create the reports in the `reports` directory.

## Usage

Images and videos can be embed by adding their path into example's metadata. For an example of how to do this, please
check out this [Sample Test](./spec/embed_graphics_spec.rb).

## Themes

Yeti is the default theme for the report, however you can change the theme by using the environment
variable `THEME=cerulean` in the terminal before you execute your tests. The example below illustrates how to use this
variable with your tests:

```bash
THEME=sketchy bundle exec rspec 
```

The included themes you can choose from are:

* cerulean
* litera
* materia
* sketchy
* spacelab

## Credits

This library is forked from [vbanthia/rspec_html_reporter](https://github.com/vbanthia/rspec_html_reporter). The
original credit goes to *[kingsleyh](https://github.com/kingsleyh)*
for [kingsleyh/rspec_reports_formatter](https://github.com/kingsleyh/rspec_reports_formatter)

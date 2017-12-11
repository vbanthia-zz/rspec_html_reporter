# RSpec HTML Reporter Android Example

## Dependencies
- [NodeJS](https://nodejs.org/en/)
- [Ruby](https://www.ruby-lang.org/en/) > v2.2

# Installation
1. Git clone

  ```bash
  git clone git@github.com:vbanthia/rspec_html_reporter.git
  cd rspec_html_reporter/examples/android
  ```

2. Install appium & other node dependencies

  ```bash
  npm install
  ```
  **Note** You will also need to install all the [Appium Dependencies for Android](https://github.com/appium/appium#android-requirements)

3. Install ruby dependencies

  ```bash
  bundle install --path=bundler/vendor

  ## In case bundler is not installed, installed it using below command
  gem install bundler
  ```

# Running

  ```bash
  bundle exec rake
  ```

# Reports

Reports will be in `./reports/` folder.

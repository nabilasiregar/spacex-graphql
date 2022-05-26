require 'capybara/cucumber'
require 'capybara-screenshot/cucumber'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'site_prism'
require 'dotenv'
require 'rspec/expectations'
require 'rspec/retry'
require 'active_support/all'
require 'byebug'
require 'rest-client'
require 'cucumber-api'
require 'uri'
require 'net/http'
require_relative '../lib/base_helper'

include RSpec::Matchers
include BaseHelper

# to load environment variable on .env file into ENV variable
Dotenv.load

SHORT_TIMEOUT = 30
DEFAULT_TIMEOUT = 60

report_root = File.absolute_path('./report')

if ENV['REPORT_PATH'].nil? || ENV['REPORT_PATH'] == ''
  # clear report files
  puts '=====:: Delete report directory via env.rb'
  FileUtils.rm_rf(report_root, secure: true)
  FileUtils.mkdir_p report_root

  # init report files
  ENV['REPORT_PATH'] = 'sample_report'
  puts "=====:: about to create report #{ENV['REPORT_PATH']} via env.rb"
end

path = report_root.to_s
FileUtils.mkdir_p path

browser_options = Selenium::WebDriver::Chrome::Options.new
browser_profile = Selenium::WebDriver::Chrome::Profile.new

if ENV['BROWSER'].eql? 'chrome_headless'
  browser_options.headless!
  browser_options.add_argument('--no-sandbox')
  browser_options.add_argument('--disable-gpu')
  browser_options.add_argument('--disable-dev-shm-usage')
  browser_options.add_argument('--enable-features=NetworkService,NetworkServiceInProcess')
end

browser_options.add_preference(:browser, set_download_behavior: { behavior: 'allow' })
browser_options.add_preference('plugins.always_open_pdf_externally', true)
browser_options.add_preference(:plugins, always_open_pdf_externally: true)
browser_options.add_preference('profile.geolocation.default_content_setting', 1)
browser_options.add_preference('profile.default_content_setting_values.geolocation', 1)

Capybara.register_driver :chrome do |app|
  browser_options.add_argument('--window-size=1440,877')
  browser_options.add_argument('--user-agent=selenium')

  client = Selenium::WebDriver::Remote::Http::Default.new
  client.open_timeout = 60
  client.read_timeout = 300

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: browser_options,
    http_client: client,
    profile: browser_profile
  )
end

Capybara::Screenshot.register_driver(:chrome) do |driver, path|
  driver.browser.save_screenshot path
end

Capybara.default_driver = if ENV['CI'] == 'true'
                            # run automation on remote firefox driver
                            :selenium
                          else
                            # run automation on chrome driver
                            :chrome
                          end

Capybara::Screenshot.autosave_on_failure = true
Capybara::Screenshot.prune_strategy = { keep: 50 }
Capybara::Screenshot.append_timestamp = true
Capybara::Screenshot.webkit_options = {
  width: 1440,
  height: 877
}
Capybara.save_path = "#{path}/screenshots"

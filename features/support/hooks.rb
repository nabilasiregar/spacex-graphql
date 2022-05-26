Before do |scenario|
  Capybara.app_host = ENV['BASE_URL']

  Capybara.default_max_wait_time = DEFAULT_TIMEOUT
  Capybara.javascript_driver = :chrome
  Selenium::WebDriver.logger.level = :debug
  Selenium::WebDriver.logger.output = 'selenium.log'

  @pages = App.new
  @tags = scenario.source_tag_names

  p "Scenario to run: #{scenario.name}"
end

After do |scenario|
  # take screenshot to find out what happen when fails
  if scenario.failed?
    p 'test failed!'
    p "Getting screen shoot in session #{Capybara.session_name}"
    Capybara.using_session_with_screenshot(Capybara.session_name.to_s) do
      # screenshots will work and use the correct session
    end
  end

  Capybara.session_name = :default

  # to embed testcase status and id on report json
  puts scenario.status.to_s
  puts "closed at #{page.current_url}"
end

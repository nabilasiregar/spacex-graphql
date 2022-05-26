module BaseHelper
  def find_xpath(locator, timeout = 3)
    short_wait.until { find(:xpath, locator, wait: timeout) }
  end

  def find_css(locator, timeout = 3)
    short_wait.until { find(:css, locator, wait: timeout) }
  end

  def short_wait(time_out = SHORT_TIMEOUT)
    Selenium::WebDriver::Wait.new(
      timeout: time_out,
      interval: 0.2,
      ignore: Selenium::WebDriver::Error::NoSuchElementError,
      message: "element not found on the current screen after waiting #{time_out} seconds"
    )
  end

  def waiting_for_page_ready
    sleep 1
    wait_for_ajax
  end

  def wait_for_ajax
    max_time = Capybara::Helpers.monotonic_time + Capybara.default_max_wait_time
    while Capybara::Helpers.monotonic_time < max_time
      finished = finished_all_ajax_requests?
      finished ? break : sleep(1)
    end
    raise 'wait_for_ajax timeout' unless finished
  end

  def finished_all_ajax_requests?
    page.evaluate_script(<<~EOS
      ((typeof window.jQuery === 'undefined')
       || (typeof window.jQuery.active === 'undefined')
       || (window.jQuery.active === 0))
      && ((typeof window.injectedJQueryFromNode === 'undefined')
       || (typeof window.injectedJQueryFromNode.active === 'undefined')
       || (window.injectedJQueryFromNode.active === 0))
      && ((typeof window.httpClients === 'undefined')
       || (window.httpClients.every(function (client) { return (client.activeRequestCount === 0); })))
    EOS
                        )
  end

  def characters_cleaner
    self.match(/^[^\(]+|(\)).*/)[0].strip
  end
end
World(BaseHelper)

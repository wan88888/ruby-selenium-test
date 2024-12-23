# frozen_string_literal: true

require 'selenium-webdriver'
require 'time'

# Set up Chrome options
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')

driver = Selenium::WebDriver.for :chrome, options: options

# File to store the HTML report
report_file = 'test_report.html'
File.open(report_file, 'w') do |file|
  file.puts '<html><head><title>Test Report</title></head><body>'
  file.puts '<h1>Test Report</h1>'
  file.puts "<p>Test started at #{Time.now}</p>"

  # Navigate to a webpage
  driver.navigate.to 'http://www.google.com'
  file.puts "<p>Navigated to: <a href='#{driver.current_url}'>#{driver.current_url}</a></p>"

  # Find the search box and enter a query
  search_box = driver.find_element(name: 'q')
  search_box.send_keys 'Selenium WebDriver'
  search_box.submit
  file.puts "<p>Search submitted at #{Time.now}</p>"

  # Wait for results to load and display
  wait = Selenium::WebDriver::Wait.new(timeout: 10)
  wait.until { driver.title.include? 'Selenium WebDriver' }

  # Log the page title
  file.puts "<p>Page title is #{driver.title}</p>"
  file.puts "<p>Test completed successfully at #{Time.now}</p>"
rescue StandardError => e
  # Log any errors
  file.puts "<p>Error occurred: #{e.message}</p>"
ensure
  # Close the browser
  driver.quit
  file.puts '</body></html>'
end

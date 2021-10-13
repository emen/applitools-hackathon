require_relative '../resources/test_properties'
require_relative '../resources/page_objects'
require_relative '../resources/eyes_manager'
require_relative '../resources/grid_manager'

RSpec.configure do |config|
  config.before(:all) do
    GridManager.api_key = API_KEY
  end

  config.before(:each) do
    @driver = Selenium::WebDriver.for :chrome
    @driver.get APP_URL
  end

  config.after(:each) do
    @driver.quit
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

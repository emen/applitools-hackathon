describe 'Accessibility' do
  before(:all) do
    @batch = Applitools::BatchInfo.new("Accessibility")
  end

  before(:each) do |example|
    @driver = Selenium::WebDriver.for :chrome
    @page = SearchPage.new(@driver)
    @driver.get APP_URL

    @em = EyesManager.new(app: 'Automation Bookstore', batch: @batch, api_key: API_KEY, test: example.description, enable_a11y: true)
    @em.open(@driver)
  end

  after(:each) do |example|
    @driver.quit
  end

  it 'Home Page' do
    @em.check_fully("Home Page")

    expect(@em).not_to have_a11y_issue
  end
end

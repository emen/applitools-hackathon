describe 'Home Page' do
  before(:all) do
    @batch = Applitools::BatchInfo.new("Home Page")
  end

  before(:each) do |example|
    @driver = Selenium::WebDriver.for :chrome
    @page = SearchPage.new(@driver)
    @driver.get APP_URL + '?abtest=1'

    @em = EyesManager.new(app: 'Automation Bookstore', batch: @batch, api_key: API_KEY, test: example.description)
    @em.open(@driver)
  end

  after(:each) do |example|
    @driver.quit

    if example.exception
      @em.abort_async
    else
      @em.close
    end
  end

  it 'Displays Books' do
    @em.check_fully("Home Page")
  end
end

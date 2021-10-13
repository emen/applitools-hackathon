describe 'Search Tests' do
  before(:all) do
    @batch = Applitools::BatchInfo.new("Search")
  end

  before(:each) do |example|
    @driver = Selenium::WebDriver.for :chrome
    @page = SearchPage.new(@driver)
    @driver.get APP_URL

    @em = EyesManager.new(api_key: API_KEY, app: 'Automation Bookstore', batch: @batch, test: example.description)
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

  it 'Search By Full Title' do
    keyword = "Agile Testing"
    @page.search(keyword)

    @em.check_fully("Search Result by Full Title")
  end

  it 'Search By Partial Title' do |e|
    keyword = 'Test'
    @page.search(keyword)

    @em.check_fully("Search Result by Partial Title")
  end
end

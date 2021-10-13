describe 'Home Page' do
  before(:all) do
    GridManager.batch = "Home Page (Grid)"
  end

  before(:each) do |example|
    @driver.get APP_URL + '?abtest=1'

    @gm = GridManager.new(app: 'Automation Bookstore',  test: example.description)
    @gm.open(@driver)

    @page = SearchPage.new(@driver)
  end

  it 'Displays Books' do
    @gm.check_fully("Home Page")
    @gm.raise_if_visual_difference
  end
end

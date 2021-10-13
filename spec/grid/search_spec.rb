describe 'Search Tests' do
  before(:all) do
    GridManager.batch = "Search (Grid)"
  end

  before(:each) do |example|
    @gm = GridManager.new(app: 'Automation Bookstore', test: example.description)
    @gm.open(@driver)

    @page = SearchPage.new(@driver)
  end

  after(:each) do |example|
    @gm.raise_if_visual_difference
  end

  it 'Search By Full Title' do
    keyword = "Agile Testing"
    @page.search(keyword)

    @gm.check_fully("Search Result by Full Title")
  end

  it 'Search By Partial Title' do |e|
    keyword = 'Test'
    @page.search(keyword)

    @gm.check_fully("Search Result by Partial Title")
  end
end

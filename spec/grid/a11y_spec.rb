describe 'Accessibility' do
  before(:all) do
    GridManager.batch = "Accessibility (Grid)"
  end

  before(:each) do |example|
    @em = GridManager.new(app: 'Automation Bookstore', test: example.description, enable_a11y: true)
    @em.open(@driver)

    @page = SearchPage.new(@driver)
  end

  it 'Home Page' do
    @em.check_fully("Home Page")

    expect(@em).not_to have_a11y_issue
  end
end

class SearchPage
  
  SEARCH_BAR = {id: "searchBar" }
  VISIBLE_BOOKS = {xpath: "//li[not(contains(@class, 'ui-screen-hidden'))]"}
  HIDDEN_BOOKS = {xpath: "//li[contains(@class, 'ui-screen-hidden')]"}
  TITLE_ATTRIBUTE = {xpath: ".//h2[contains(@id, '_title')]"}
  AUTHOR_ATTRIBUTE = {xpath: ".//p[contains(@id, '_author')]"}
  PRICE_ATTRIBUTE = {xpath: ".//p[contains(@id, '_price')]"}
  IMAGE_ATTRIBUTE = {xpath: ".//img[contains(@id, '_thumb')]"}
  
  attr_accessor :driver, :wait
  
  def initialize(driver)
    self.driver = driver
    self.wait = Selenium::WebDriver::Wait.new(:timeout => 5)
  end

  def search_books(text)
    search(text, true)
  end

  def search(text, waitForHidden=false)
    clear_search
    
    before_search = get_number_of_visible_books
    
    self.driver.find_element(SEARCH_BAR).send_keys(text)
    self.wait.until { get_number_of_visible_books < before_search and get_number_of_visible_books > 0 }

    if waitForHidden
      self.wait.until { self.driver.find_element(HIDDEN_BOOKS).displayed? }
    end
  end

  def clear_search
    self.driver.find_element(SEARCH_BAR).clear
    self.wait.until { self.driver.find_elements(HIDDEN_BOOKS).size == 0 }
  end

  def get_number_of_visible_books
    find_visible_books.size
  end

  def is_book_visible?(title)
    books = find_visible_books
    books.any? { |b| b.find_element(TITLE_ATTRIBUTE).text.downcase == title.downcase }
  end
  
  def find_visible_books
    self.driver.find_elements(VISIBLE_BOOKS)
  end

  def book_visible(book)
    books = find_visible_books
    correct = true

    books.each do |b|
      correct = true

      if !compare(book[:title], b.find_element(TITLE_ATTRIBUTE).text)
        correct = false
      end
      
      if !compare(book[:author], b.find_element(AUTHOR_ATTRIBUTE).text)
        correct = false
      end
      
      if !compare(book[:price], b.find_element(PRICE_ATTRIBUTE).text)
        correct = false
      end
      
      if !b.find_element(IMAGE_ATTRIBUTE).attribute("src").includes? book[:image]
        correct = false
      end
    end

    correct
  end

  def compare(expected_value, book)
    actual_value = book
    puts "Comparing #{expected_value} with #{actual_value}"
    expected_value.downcase == actual_value.downcase
  end
  
end
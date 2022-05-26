class App
  def wikipedia_page
    @wikipedia_page ||= WikipediaPage.new
  end
end
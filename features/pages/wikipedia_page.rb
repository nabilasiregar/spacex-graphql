class WikipediaPage < SitePrism::Page
  set_url '/wiki/SpaceX'

  element :page_header, :xpath, "//h1[@id='firstHeading' and contains(text(),'SpaceX')]"
  element :infobox_key_people_ceo, :xpath, "//table[@class='infobox vcard']//a[@title='Chief executive officer']"

  def get_ceo_name
    infobox_key_people_ceo.find(:xpath, './/parent::li').text.characters_cleaner
  end
end
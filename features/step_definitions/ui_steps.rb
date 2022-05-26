Given(/^user is on SpaceX wikipedia page$/) do
  @pages.wikipedia_page.load
  waiting_for_page_ready
  short_wait.until { @pages.wikipedia_page.has_page_header? }
end

When(/^user find SpaceX CEO name on wikipedia$/) do
  expect(@pages.wikipedia_page.infobox_key_people_ceo.text).to eq 'CEO'
end

And(/^user grab CEO name from wikipedia as "(.*)"$/) do |v|
  ceo_name = @pages.wikipedia_page.get_ceo_name

  instance_variable_set("@#{v}", ceo_name) 
end
include Ironman

When(/^user send POST request using "(.*?).graphql"$/) do |filename|
  path_body = "#{Dir.pwd}/features/schema/#{filename}.graphql"
  query = Ironman::Client.parse File.read(path_body)
  @gql_name = Ironman::Client.query(query)
end

And(/^user grab CEO name from query as "(.*)"$/) do |v|
  instance_variable_set("@#{v}", @gql_name.data.company.ceo)
end

Then(/^wikipedia name should match query name$/) do
  expect(@gql_name).to eq @wiki_name
end 
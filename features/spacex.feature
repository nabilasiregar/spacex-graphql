Feature: API x UI
  Scenario: CEO of SpaceX stated by wikipedia should match graphql query result
    Given user is on SpaceX wikipedia page
    When user find SpaceX CEO name on wikipedia
    And user grab CEO name from wikipedia as "wiki_name"
    And user send POST request using "spacex_schema.graphql"
    And user grab CEO name from query as "gql_name"
    Then wikipedia name should match query name
    
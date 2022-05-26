require 'graphql/client'
require 'graphql/client/http'
require 'rest-client'

module Ironman
  # Configure GraphQL endpoint using the basic HTTP network adapter.
  HTTP = GraphQL::Client::HTTP.new("https://api.spacex.land/graphql") do
    def headers(context)
      {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
    end
  end

    # Fetch latest schema on init, this will make a network request
    Schema = GraphQL::Client.load_schema(HTTP)
    Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
    Client.allow_dynamic_queries = true
end


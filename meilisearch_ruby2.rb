require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem "meilisearch"
  gem "gimei"
  gem "parallel"
end

require "meilisearch"
require "gimei"
require "parallel"

MEILI_URL = "http://127.0.0.1:7700"

@index = MeiliSearch::Client.new(MEILI_URL, "MASTER_KEY")
  .index("movies")

@index.update_filterable_attributes([
  'json_field.name_1',
  'json_field.name_2',
  'json_field.name_3',
])

def search(query)
  puts "-" * 100
  puts "QUERY: #{query}"
  pp @index.search(
    query,
    {
      attributesToHighlight: ['*'],
      limit: 3,
      filter: "json_field.name_1 = \"黒田 笑弥\"",
    },
  )
end

search("しらい 山下")

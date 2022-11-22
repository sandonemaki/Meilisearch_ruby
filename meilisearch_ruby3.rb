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

MEILI_URL = "http://localhost:7700"

def documents(range)
  puts "-" * 100
  puts "generate documents"
  puts range
  puts "start #{Time.now}"
  range.map{|i|
    director = Gimei.name
    {
      id: i,
      title: Gimei.address.kanji,
      actors: 10.times.map { Gimei.name.kanji },
      director: director.kanji,
      director_kana: director.hiragana,
    }
  }.tap{
    puts "end #{Time.now}"
    puts "-" * 100
  }
end

index = MeiliSearch::Client.new(MEILI_URL, "MASTER_KEY")
          .index("movies")

Parallel.each(documents(0...10000)) { |document|
  index.add_documents(document)
}

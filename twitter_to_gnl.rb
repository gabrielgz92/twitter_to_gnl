require 'byebug'
require 'csv'
require 'date'
require_relative 'twitter_keys'

require 'twitter'
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = KEY
  config.consumer_secret     = KEY_SECRET
  config.access_token        = TOKEN
  config.access_token_secret = TOKEN_SECRET
end

tweets = client.user_timeline('BarackObama', count: 200, tweet_mode:'extended')

results = []
tweets.each do |t|
  long_tweet = client.status(t.id, tweet_mode: 'extended')
  fields = long_tweet.to_hash.slice(:created_at, :id, :full_text)
  tweet_gnl = fields.values.insert(1, long_tweet.user.name)
  tweet_gnl[0] = Time.parse(tweet_gnl[0]).strftime("%F %T")
  results << tweet_gnl
end

csv = CSV.open("tweets.csv", "a+")

results.each do |r|
  csv << r
end

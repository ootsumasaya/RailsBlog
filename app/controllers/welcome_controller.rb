
class WelcomeController < ApplicationController
  http_basic_authenticate_with name: 'uec', password: 'karate'

  def index
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_SECRET_KEY']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET_TOKEN']
    end

    # 検索
    @tweets = client.search('coffee', result_type: 'recent', exclude: 'retweets').take(100)

    # 各制限をハッシュで取得
    @rate_limits = Twitter::REST::Request.new(client, :get, '/1.1/application/rate_limit_status.json').perform
    # 検索回数上限
    @search_limit_remaining = @rate_limits[:resources][:search][:"/search/tweets"][:remaining]
    # 検索回数リセット時刻
    @search_limit_reset = Time.at(@rate_limits[:resources][:search][:"/search/tweets"][:reset])
  end
end

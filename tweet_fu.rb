require 'rubygems'
require 'twitter'


class TweetFu

  TOKENS = ['consumer_key', 'consumer_secret', 'request_key', 'request_secret', 'access_key', 'access_secret']

  def initialize(credentials=YAML.load(File.read('settings.yml')))

    TOKENS.each do |token|
      self.instance_variable_set("@#{token}", credentials[token])
    end

    @oauth = Twitter::OAuth.new(@consumer_key, @consumer_secret)

    if @access_key && @access_secret
      @oauth.authorize_from_access(@access_key, @access_secret)
    elsif @request_key && @request_secret
      @oauth.authorize_from_request(@request_key, @request_secret)

      @access_key = oauth.access_token.token
      @access_secret = oauth.access_token.secret
    end

    @twitter = Twitter::Base.new(@oauth)
  end

  def method_missing(method, *args, &block)
    @twitter.send(method, *args, &block)
  end

end

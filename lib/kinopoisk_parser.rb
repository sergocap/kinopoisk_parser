require 'nokogiri'
require 'httpclient'
require 'kinopoisk/movie'
require 'kinopoisk/search'
require 'kinopoisk/person'

module Kinopoisk
  SEARCH_URL = 'https://www.kinopoisk.ru/index.php?kp_query='

  NotFound = Class.new StandardError
  Denied   = Class.new StandardError do
    def initialize(msg = 'Request denied')
      super
    end
  end

  # Headers are needed to mimic proper request so kinopoisk won't block it
  def self.fetch(url)
    HTTPClient.new.get url, follow_redirect: true, header: { 'User-Agent'=>'a', 'Accept-Encoding'=>'a' }
  end

  # Returns a nokogiri document or throws an error
  def self.parse(url)
    page = fetch url

    raise NotFound, 'Page not found' if page.status != 200
    raise Denied if page.header.request_uri.to_s =~ /error\.kinopoisk\.ru|\/showcaptcha/

    Nokogiri::HTML page.body.encode('utf-8')
  rescue HTTPClient::BadResponseError
    raise Denied
  end
end

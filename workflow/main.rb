#!usr/bin/env ruby
# encoding: utf-8

require "alfred"
require "net/http"
require "uri"
require "json"

KEY = "UzXLycyn_7AJQ3KqhTdJ7fcFoCvoYFn"
SECRET = "7AJTvDNyecPFeJWhn339Ze"
SHOPPER_ID = "79427493"
Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback
  query = ARGV[0]

  # add a file feedback

  uri = URI.parse("https://api.ote-godaddy.com:443/v1/domains/available?domain=#{query}&forTransfer=false&checkType=fast&waitMs=1000")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new(uri.request_uri)
  # request.initialize_http_header({
  #     "Authorization" => "sso-key #{KEY}:#{SECRET}",
  #     "X-Shopper-Id" => "#{SHOPPER_ID}"
  # })

  response = http.request(request)

  puts fb.to_xml
end




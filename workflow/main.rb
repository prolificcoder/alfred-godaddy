#!usr/bin/env ruby
# encoding: utf-8

require "alfred"
require "net/http"
require "uri"
require "json"
require 'openssl'

KEY = "UzXLycyn_7AJQ3KqhTdJ7fcFoCvoYFn"
SECRET = "7AJTvDNyecPFeJWhn339Ze"
SHOPPER_ID = "79427493"
Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback
  alfred.with_rescue_feedback = true
  query = ARGV[0]

  # # add a file feedback
  fb.add_file_item(File.expand_path "~/Applications/")
  #
  uri = URI.parse("https://api.ote-godaddy.com:443/v1/domains/available?domain=#{query}&forTransfer=false&checkType=fast&waitMs=1000")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new(uri.request_uri)
  request.content_type = "application/json"

  response = http.request(request)

  alfred.ui.debug response.code

  if response.code.to_i == 200
    json_response = JSON.parse(response.body)
    if json_response['available']
      fb.add_item({
                      :uid => json_response['domain'],
                      :subtitle => json_response['domain'],
                      :title => 'Your domain is available',
                      :valid => "yes",
                  })
    else
      fb.add_item({
                      :uid => json_response['domain'],
                      :subtitle => json_response['domain'],
                      :title => 'Your domain is not available',
                      :valid => "no",
                  })
    end
  else
    fb.add_item({
                    :subtitle => "exactmatch needs complete domain",
                    :title => "Enter complete domain",
                    :valid => "no",
                })
  end

  puts fb.to_xml
end




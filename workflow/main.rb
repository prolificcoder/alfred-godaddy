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

def make_api_query(query,search_type,query_parameter)
  uri = URI.parse("https://api.ote-godaddy.com:443/v1/domains/#{search_type}?#{query_parameter}=#{query}&checkType=fast&waitMs=1000")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new(uri.request_uri)
  request.content_type = "application/json"
  response = http.request(request)
end

Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback
  alfred.with_rescue_feedback = true
  query = ARGV[0]

  # # add a file feedback
  fb.add_file_item(File.expand_path "~/Applications/")
  response = make_api_query(query,'available','domain')
  alfred.ui.debug response.code

  if response.code.to_i == 200
    json_response = JSON.parse(response.body)
    alfred.ui.debug json_response
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
                    :title => "API didn't respond with valid data",
                    :valid => "no",
                })
  end
  puts fb.to_xml
end




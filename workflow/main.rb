#!usr/bin/env ruby
# encoding: utf-8
require "alfred"
require "json"
require_relative 'helper'

Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback
  alfred.with_rescue_feedback = true
  query = ARGV[0]

  # # add a file feedback
  fb.add_file_item(File.expand_path "~/Applications/")

  uri = URI.parse("https://api.ote-godaddy.com:443/v1/domains/available?domain=#{query}&checkType=fast&waitMs=1000")
  response = make_api_query(uri)
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
                    :title => "API didn't respond with valid data",
                    :valid => "no",
                })
  end
  puts fb.to_xml
end




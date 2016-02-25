#!/usr/bin/env ruby
require 'net/http'
require 'json'

# this job will track metrics of a facebook page

# Config
# ------
# the fb id or username of the page you’re planning to track
facebook_graph_username = ENV['FACEBOOK_GRAPH_USERNAME'] || 'NitrousIO'
facebook_access_token = ENV['FACEBOOK_ACCESS_TOKEN']

SCHEDULER.every '1m', :first_in => 0 do |job|
  http = Net::HTTP.new("graph.facebook.com")
  response = http.request(Net::HTTP::Get.new("/#{facebook_graph_username}?access_token=#{facebook_access_token}"))
  if response.code != "200"
    puts "facebook graph api error (status-code: #{response.code})\n#{response.body}"
  else
    data = JSON.parse(response.body)
    if data['likes']
      if defined?(send_event)
        send_event('facebook_likes', current: data['likes'])
      else
        printf "Facebook likes: %d\n", data['likes']
      end
    end
  end
end
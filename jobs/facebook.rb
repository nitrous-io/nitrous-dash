#!/usr/bin/env ruby
require 'open-uri'
require 'json'
require 'dotenv'
require 'cgi'
Dotenv.load

# this job will track metrics of a facebook page

facebook_graph_username = ENV['FACEBOOK_GRAPH_USERNAME'] || 'NitrousIO'
facebook_access_token = CGI.escape(ENV["FACEBOOK_APP_ID"] + "|" + ENV["FACEBOOK_APP_SECRET"])

SCHEDULER.every '10m', :first_in => 0 do |job|
  response = URI.parse("https://graph.facebook.com/#{facebook_graph_username}?fields=likes&access_token=#{facebook_access_token}").read
  data = JSON.parse(response)
  send_event('facebook_likes', current: data['likes']) if data['likes']
end

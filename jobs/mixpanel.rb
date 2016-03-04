#!/usr/bin/env ruby
require 'open-uri'
require 'json'
require 'dotenv'
require 'cgi'
Dotenv.load

# prepare query string
# args = all query parameters going to be sent out with the request
#        (e.g. api_key, unit, interval, expire, format, etc.) excluding sig.
# Output: api_key=ed0b8ff6cc3fbb37a521b40019915f18event=["pages"]
#         expire=1248499222format=jsoninterval=24unit=hour
def mixpanel_signature(args = [], api_secret = ENV["MIXPANEL_API_SECRET"])
  sig = md5(args.sort.join + api_secret)
  return sig
end

SCHEDULER.every '10m', :first_in => 0 do |job|

  sig = mixpanel_signature(['IDE%20User%20Saved%20File', ])
  puts sig

  response = URI.parse("https://mixpanel.com/api/2.0/events?sig=#{sig}").read
  data = JSON.parse(response)
  send_event('file_saves_30_day', current: data['file_saves']) if data['file_saves']
end

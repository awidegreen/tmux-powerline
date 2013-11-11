#!/usr/bin/env ruby

require "net/http"
require "json"

uri = URI.parse("https://blockchain.info/ticker")
response = Net::HTTP.get(uri)
json = JSON::parse(response)

currency = ARGV[0]
currency ||= "eur"
e = json[currency.upcase]
res = "#{e["15m"]}#{e["symbol"]}"
puts res

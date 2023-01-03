# frozen_string_literal: true

# Helper class log into a website and reset invalid login counter.
class ValidLogin
  class Exception < StandardError; end

  def initialize(uri:, username:, password:, success_code:)
    @uri = uri
    @username = username
    @password = password
    @success_code = success_code
  end

  def login
    res = Net::HTTP.post_form(@uri, username: @username, password: @password)
    return res if res.code == @success_code

    puts "Headers: #{res.to_hash.inspect}"
    puts res.body
    raise ValidLogin::Exception, res
  end
end

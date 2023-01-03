# frozen_string_literal: true

# Initializes a rand IP address of the form:
# rand(1...255).0.j.i, calling #to_s
# return a string to use, while #increment increases the ip
class BypassWAF
  def initialize
    @net = rand(1...255)
    @subnet = rand(1...255)
    @namespace = 0
    @host = 0
  end

  def increment
    @host = if @host >= 255
              @namespace += 1
              0
            else
              @host + 1
            end
  end

  def to_s
    "#{@net}.#{@subnet}.#{@namespace}.#{@host}"
  end

  def inspect
    to_s
  end
end

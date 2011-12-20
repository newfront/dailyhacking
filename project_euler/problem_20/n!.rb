#!/usr/bin/env ruby

# 10! = 10 x 9 x 8 x 7 x 6 x 5 x 4 x 3 x 2 x 1

def num!(num)
  countdown = num
  lastsum = num
  while countdown >= 1
    puts countdown
    lastsum = lastsum * countdown
    countdown -= 1
  end
  return lastsum
end

def get_digits(num)
  strdigits = num.to_s
  sum = 0
  strdigits.each_char{|c|
    sum += c.to_i
  }
  return sum
end

puts get_digits(num!(100))
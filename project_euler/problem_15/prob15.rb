#!/usr/bin/env ruby

def num!(num)
  countdown = num
  lastsum = num
  while countdown >= 1
    #puts countdown
    lastsum = lastsum * countdown
    countdown -= 1
  end
  return lastsum
end

n,m = 20,20

result = num!(n+m) / (num!(n)*num!(m))

puts result

# 13,784,652,882
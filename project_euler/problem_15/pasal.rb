#!/usr/bin/env ruby

=begin

[n:k] =       n!
        ---------------
           k! (n-k)!
           
[6:3] = 6 * 5 * 4 * 3 * 2 * 1
        ------------------------  = 20
        3 * 2 * 1 * (3 * 2 * 1)

=end

def factorial!(num, current=1)
  while num > 1
    current *= num
    num -= 1
  end
  return current
end

def pascal(row,col)
  return factorial!(row,1) / (factorial!(col,factorial!(row - col)))
end

#puts pascal(6,3)
#puts pascal(6,3) #20
n,m = 20,20
result = factorial!(n+m,1) / (factorial!(n,factorial!(m,1)))

puts result

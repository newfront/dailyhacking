#!/usr/bin/env ruby

=begin
Let d(n) be defined as the sum of proper divisors of n (numbers less than n which divide evenly into n). 
If d(a) = b and d(b) = a, where a  b, then a and b are an amicable pair and each of a and b are called amicable numbers.
For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20, 22, 44, 55 and 110; therefore d(220) = 284. The proper divisors of 284 are 1, 2, 4, 71 and 142; so d(284) = 220.
Evaluate the sum of all the amicable numbers under 10000.
=end
@memotization = {}

def d(num)
  even_divisibles = 0
  nums = []
  target = num
  num -= 1
  while num >= 1
    #puts num
    if target % num == 0
      #puts num
      even_divisibles += num
      nums << num
    end
    #even_divisibles << num if target % num == 0
    num -= 1
  end
  return {:sum => even_divisibles, :nums => nums}
end

def is_amicable_pair(target)
  a = d(target)
  
  #puts target
  #puts a[:sum]
  
  b = d(a[:sum])
  
  if b[:sum] == target and target != a[:sum]
    puts "----------"
    puts "#{target.to_s} has the following even divisors #{a[:nums].join(",").to_s} with a sum of #{a[:sum].to_s}"
    puts "#{a[:sum].to_s} has the following even divisors #{b[:nums].join(",").to_s} with a sum of #{b[:sum].to_s}"
    puts "----------"
    @memotization[target] = a[:nums]
    @memotization[a[:sum]] = b[:nums]
  else
    #puts "is not amicable pair"
  end
end

def gather_amicable_pairs_to(max)
  1.upto(max).each{|num|
    #puts num
    is_amicable_pair(num)
  }
end

gather_amicable_pairs_to(9999)

#puts @memotization.inspect

@sum = 0
@unique = []

puts @memotization.inspect

@memotization.each{|k,v|
  @sum += k
}
#@unique.each{|num|
#  @sum += num
#}
puts @sum

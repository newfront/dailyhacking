#!/usr/bin/ruby

# 2520 is the smallest number that can be divided by each of the numbers from 1 to 10 
# without any remainder.

# What is the smallest positive number that is evenly divisible by all of the numbers 
# from 1 to 20?

# Smallest Positive Number evenly divisible by all numbers 1 - 20

#1.upto(){|target|
#  @tests = []
  #puts "TARGET: #{target.to_s}\n"
#  1.upto(20){|divisor|
    #puts "#{target.to_s}/#{divisor.to_s} = #{(target.to_f / divisor.to_f).to_s}"
#    @tests << ((target.to_f / divisor.to_f) % 2 == 0)
#  }
  #puts @tests.inspect
#  puts "#{target.to_s} works with full set"  if !@tests.include? false
  #puts
  #@tests = nil 
#}
@solutions = []
1.upto(100000000 000){|numerator|
  @results = []
  1.upto(20){|divisor|
    puts "#{numerator.to_f.to_s}/#{divisor.to_f.to_s} = #{(numerator.to_f/divisor.to_f).to_s}"
    @results << ((numerator.to_f % divisor) == 0)
  }
  @solutions << numerator if !@results.include? false
}
puts "SOLUTION SET: "
puts @solutions.inspect
#!/usr/bin/ruby

# PROBLEM ( PROJECT EULER #4 )
# A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91  99.
# Find the largest palindrome made from the product of two 3-digit numbers.

@palindromic = []

def calculate_numbers(start,finish,&block)
	start.upto(finish) do |n| 
	  start.upto(finish) do |test|
	    #tmp = n*test
	    block.call(n*test)
	  end
	end
end

# Check if each number is palindromic
# Each number is palindromic if its first half is equal to second half reversed
def is_palindromic? num
  begin
    length = num.to_s.length
    half = length.to_f/2.to_f
    return num if num.to_s[0,half] == num.to_s.reverse[0,half]
  rescue
    puts "error on block...."
  end
end

# calculate each number in the range against itself against the range
#  push number from each result to block
calculate_numbers(100,999) do |n|
  # push palindrom to set, ensure one of each number, should only be one...
  @palindromic << n if (is_palindromic? n) && (!@palindromic.include? n)
end

# show results, sorted from smallest to largest
puts @palindromic.sort.inspect
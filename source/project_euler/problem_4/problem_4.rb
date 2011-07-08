#!/usr/bin/ruby

# PROBLEM ( PROJECT EULER #4 )
# A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91  99.
# Find the largest palindrome made from the product of two 3-digit numbers.

@palindromic = []

def calculate_numbers(start,finish,&block)
	start.upto(finish) do |n| 
	  start.upto(finish) do |test|
	    tmp = n*test
	    block.call(tmp)
	  end
	end
end

# Check if each number is palindromic
# Each number is palindromic if its first half is equal to second half reversed
def is_palindromic? num
  begin
    length = num.to_s.length
    half = length.to_f/2.to_f
    if length == 2
      return num if num[0] == num[1]
    else
      num_as_array = num.to_s.scan(/./)
      first_half = num_as_array.join[0,half]
      second_half = num_as_array.join.reverse[0,half]
      return num if first_half == second_half
    end
  rescue
    puts "error on block...."
  end
end

# calculate each number in the range against itself against the range
#  push number from each result to block
calculate_numbers(100,999) do |n|
  # push palindrom to set, ensure one of each number, should only be one...
  if (is_palindromic? n) && (!@palindromic.include? n)
    @palindromic << n
  end
end

# show results, sorted from smallest to largest
puts @palindromic.sort.inspect
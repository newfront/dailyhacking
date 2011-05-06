#!/usr/bin/ruby

cap = 999
is_multiple_of = [3,5]

@result = 0

(0..cap).each {|num| 
	
	  # can only be either 3 or 5, not both
	  if (num % is_multiple_of[0] == 0 || num % is_multiple_of[1] == 0)
			puts "num #{num.to_s} is a multiple of 3 or 5"
			@result = @result + num
			puts "RESULT: #{@result.to_s}"
		end	
}

puts "TOTAL: #{@result.to_s}"
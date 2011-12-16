#!/usr/bin/env ruby

# what is the sum of the digits of the number 2**1000?

def get_sum_of_digits(num)
	num = num.to_s
	@result = 0
	num.each_char{|n|
		@result += n.to_i
	}
	return @result
end

puts "The solution is #{get_sum_of_digits(2**1000).to_s}"
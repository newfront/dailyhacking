#!/usr/bin/ruby

@start = 100
@cap = 999

def calculate_numbers(start,finish,&block)
	
	start.upto(finish) do |n| 
	  start.upto(finish) do |test|
	    tmp = n*test
	    puts "#{n.to_s}*#{test.to_s} = #{tmp.to_s}"
	    puts tmp.to_s
	    #(@val ||=[]) << (tmp)
	    block.call(tmp)
	  end
	end
	
end

# ["9", "9", "9", "0", "0"]
# 99900
# 99 9 00

def is_palindromic? num
  length = num.to_s.length
  half = length.to_f/2.to_f
  
  #puts (half % 2 == 0).to_s
  
  #puts 
  #puts "#{num.to_s} length is #{length.to_s} half_size = #{half.to_s}"
  # check first half, second half (reversed) if num/2 % 2
  #puts (length.to_f / 2.to_f).to_s
  
  # if number is 2 digits
  if length == 2
    #puts "Number is 2 digit"
    return num if num[0] == num[1]
    
  else
   # puts "Number divided by 2 is even number"
    num_as_array = num.to_s.scan(/./)
    #puts num_as_array.inspect
    first_half = num_as_array.join[0,half]
    second_half = num_as_array.join.reverse[0,half]
    #puts "first half: #{first_half} | second half: #{second_half}"
    return num if first_half == second_half
    #puts
  end
  #puts
    
end

@palindromic = []
calculate_numbers(@start,@cap) do |n|
  if (is_palindromic? n) && (!@palindromic.include? n)
    @palindromic << n
  end
end

puts @palindromic.sort.inspect
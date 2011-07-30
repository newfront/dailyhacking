#!/usr/bin/env ruby

@list = [1,2,4,5,7,9,25]
@list2 = [4,6,8,11,29]
@result = []

def merge(list,list2)

	if list.size == 1 && list2.size == 1
		if list[0] > list2[0]
		  @result << list2[0]
		  @result << list[0]
		elsif list[0] < list2[0]
		  @result << list[0]
		  @result << list2[0]
		else
		  @result << list[0]
		  #@result << list2[0] // same value
		end
		return @result
	else
	  # compare first element of either list to see what is bigger
	  if list[0] > list2[0]
	    puts "#{list[0].to_s} > #{list2[0].to_s}"
	    @result << list2[0]
	    list2.slice!(0) if list2.size > 1 # remove smallest element
	    #@result << list[0]
	  elsif list[0] < list2[0]
      puts "#{list[0].to_s} < #{list2[0].to_s}"
	    @result << list[0]
	    list.slice!(0) if list.size > 1 # remove smallest element
	    #@result << list2[0]
	  else
	    # results are the same
	    @result << list[0] # don't worry about the second, it is a repeat
	    list2.slice!(0) if list2.size > 1 # remove compared elements
	    list.slice!(0) if list.size > 1 # remove compared elements
	  end
	  
    # recursively run until list.size || list2.size == 1
    puts list.inspect
    puts list2.inspect
    merge(list,list2)
	end

end

puts "test merging lists"
merged_list = merge(@list,@list2)
puts merged_list.inspect
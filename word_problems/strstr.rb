#!/usr/bin/env ruby

def strstr(haystack, needle)
    # haystack is of a particular length
    # needle is of a particular length
    h_len = haystack.size
    n_len = needle.size
    
    unless h_len >= n_len
        return false
    end
    
    # continue
    
    # how many test cycles must we run to compare haystack against needle
    #num_tests = (h_len / n_len).ceil
    
    (0..h_len).each do |position| 
        test = haystack[position, n_len]
        if test == needle
            puts "needle: #{needle} is equal to haystack substr: #{test}"
            return position
        end
    end
    return false
end

puts strstr("san francisco", "ran")

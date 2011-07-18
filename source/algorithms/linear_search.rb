#!/usr/bin/env ruby

# linear search algorithm

def benchmark(&block)
  
  t_start = Time.now
  block.call
  t_end = Time.now
  
  puts "Total Time: #{(t_end.to_f - t_start.to_f)} seconds"
  
end

$tests = 0

# turning on output will significantly increase running time by a factor of k
# k (running time) = range upto k where k is value in range
# if value is not in range, k = range

# difference in speeds
# (with output) = Total Time: 32.703356981277466 seconds
# (without output) = Total Time: 0.4096109867095947 seconds

# ultimately, it is about 80% less efficient to run with output

def linear_search(range,value)
  
  @range = range.to_a
  
  # iterate through start to end of range
  @range.each do |comparison|
    
    # return true if we have a match
    
    unless comparison != value
      $tests += 1
      #puts "Total Tests: #{$tests.to_s}. matched: #{comparison.to_s} == #{value.to_s}"
      return true
    else
      $tests += 1
      #puts "Total Tests: #{$tests.to_s}. No Match. test again"
    end 
    
  end
  
  return false
  
end

benchmark { linear_search((0..2000000),2000000) }
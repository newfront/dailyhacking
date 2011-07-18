#!/usr/bin/env ruby

def benchmark(&block)
  
  t_start = Time.now
  block.call
  t_end = Time.now
  
  puts "Total Time: #{(t_end.to_f - t_start.to_f)} seconds"
  
end

$loops = 0
def binary_search(range,value)
  # binary search algorithm
  # chop range in half, test if value is greater, less then chunk[0], chunk[1]
  # continue test on chunk that passes condition, until 2 values left
  $loops += 1 # adds about .001 more time to algorithm
  
  #@range = range.each.map{|val| val} # adds about 50% more time to algorithm
  @range = range.to_a
  
  puts "Size of range: #{@range.size.to_s}"
  
  unless @range.size <= 2
    
    # chop range in half
    # test if value is in first or second chunk
    ranges = [] 
    ranges << @range[0,(@range.size/2)]
    ranges << @range[(@range.size/2),@range.size]
    
    #puts "size of ranges[0] #{ranges[0].size.to_s}"
    #puts "size of ranges[1] #{ranges[1].size.to_s}"
    
    # test if value is less than or equal to first value in ranges[1] or last value of ranges[0]
    if value >= ranges[1][0]
      #puts "#{value.to_s} should be searched for in ranges[1]"
      puts ranges[1].inspect
      @upper = ranges[1].last
      @lower = ranges[1].first
    else
      #puts "#{value.to_s} should be searched for in ranges[0]"
      @upper = ranges[0].last
      @lower = ranges[0].first
    end
     puts "Check Range of #{@lower.to_s} .. #{@upper.to_s}"
     puts "Loop #{$loops.to_s}"
    # recursivly check against new parameters
    binary_search((Range.new(@lower,@upper)),value)
    
  else
    # we have two values left, do comparison
    puts "search #{@range.inspect} for #{value.to_s}"
    puts "range only has 2 values in it, manually compare against value"
    
    if @range.first == value
      puts "value is in set: #{@range.first.to_s} == #{value.to_s}"
      return true
    elsif @range.last == value
      puts "value is in set: #{@range.last.to_s} == #{value.to_s}"
      return true
    else
      puts "value is not in the set: #{value.to_s}"
      return false
    end  
  end
  
end

# Usage
# Check from start..upper_limit of range of numbers to see if a value is contained
# Use benchmarking to see how fast the algorithm returns a solution
benchmark {binary_search(Range.new(0,2000000),100000)}

# can also call with
#benchmark { binary_search((0..2000000),100000)}
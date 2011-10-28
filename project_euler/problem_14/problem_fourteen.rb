#!/usr/bin/env ruby

# rules
# n -> n/2 (n is even)
# n -> 3n + 1 ( n is odd )

# ex: 13
# 13, 40, 20, 10, 5, 16, 8, 4, 2, 1
######################################
# (1) 13*3+1 = 40 ( even )
# (2) 40 / 2 = 20 ( even )
# (3) 20 / 2 = 10 ( even )
# (4) 10 / 2 = 5 ( odd )
# (6) 5*3+1 = 16 ( even )
# (7) 16 / 2 = 8 ( even )
# (8) 8 / 2 = 4 ( even )
# (9) 4 / 2 = 2 ( even )
# (10) 2 / 2 = 1 ( odd, but 1 )
######################################
# memotize results
######################################

@memotization = {}
@sequence = []
@best = []

@next_from_even = lambda{|num| (3*num)+1} #even
@next_from_odd = lambda{|num| num/2 } #odd

# check the number type
def is_even num
  return true if num % 2 == 0
  return false
end

# crunch the sequence
def crunch(num)
  unless !is_even(num)
    #
    return @next_from_odd[num]
  else
    #
    return @next_from_even[num]
  end
end

# build base runner
# give it a number to start with
def runner(start)
  # populate @sequence
  unless @sequence.size >= 1
    @sequence << start
  end
  # store starting point
  entry = start
  puts "#{entry}"
  s = start
  is_one = false
  #puts "starting"
  
  while !is_one do
    # is this available in the memotization table?
    if @memotization.has_key?(s)
      #puts "**************#{entry.to_s}*************\n is stored in memory: #{@memotization[s].inspect}}"
      #puts "No need to grab anything else down the tree"
      @sequence = @sequence + @memotization[s]
      is_one = true
      break
    else
      result = crunch(s)
      @sequence << result
      s = result
      is_one = true if s == 1
    end
  end
  #puts @sequence.inspect
  # push computed sequences to memory
  @memotization[entry] = @sequence.uniq
  #puts entry.to_s
  #puts @memotization[entry].to_s
  #puts "complete"
  if @best.size < 1
    @best = @sequence.uniq
    #puts "current best is #{@best.inspect}"
  end
  # update best with new size
  if @best.size >= 1 && @best.size < @sequence.uniq.size
    @best = @sequence.uniq
    #puts @best.inspect
  end
  @sequence = []
end

# figure out how long it runs
def benchmark &block
  start = Time.now
  block.call()
  end_t = Time.now
  puts "Running Time: #{(end_t.to_f - start.to_f).to_s} seconds"
end

# base case: pass
#runner(13,10)
@cap = 999999
@current = 999000
benchmark{
  while @current <= @cap do
    runner(@current)
    #@cap -= 1
    @current += 1
  end
  puts "longest sequence is #{@best.size.to_s}"
  puts "sequence: #{@best.inspect}"
}

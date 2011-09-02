#!/usr/bin/env ruby

# grab the 30th number in the fibonacci sequence
# usage. > ruby fibonacci.rb 30 # 832040
@num_to = ARGV[0].nil? ? 9 : ARGV[0].to_i

def fibonacci(num)
  @count = 0
  @a,@b = 0,1
  begin
    #puts "#{@a.to_s}:#{@b.to_s}"
    @a,@b = @b,@a+@b
    @count += 1  
  end while  @count < num
  return @a
end

puts fibonacci(@num_to).to_s
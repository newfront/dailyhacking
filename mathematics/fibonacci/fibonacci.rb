#!/usr/bin/env ruby

def fibonacci(num)
  @count = 0
  @a,@b = 0,1
  begin
    puts "#{@a.to_s}:#{@b.to_s}"
    @a,@b = @b,@a+@b
    @count += 1  
  end while  @count < num
  return @a
end

puts fibonacci(9).to_s
=begin
2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.

What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?
=end

def is_evenly_divisible(number,against)
  
  #return false unless number % 10 == 0
  if number % against == 0
    return true
  end
  
  return false
  
end

def test_for_evenly_divisible(number,range)
  
  range.each{|test|
    return false unless is_evenly_divisible(number,test)
  }
  return true
end


#test = 2520
#puts test_for_evenly_divisible(test,(1..10)) #true

#@divisible_by_all = []
#def generate_divisibles(values_range,must_include_range)
  
#  values_range.each {|test|
#    puts "test: #{test.to_s}"
#    if test_for_evenly_divisible(test,must_include_range)
#      @divisible_by_all << test
#    end
#  }
#  puts @divisible_by_all.inspect
#end

# greatest common denominator
def gcd(a,b)
  
  while (b != 0)
    
    tmp = b
    b = a % b
    a = tmp
  end
  
  return a
  
end

# lowest common multiple
def lcm(a,b)
  return (a * b) / gcd(a,b)
end

result = (1..20).inject {|c,n| lcm(c,n)}

puts result.to_s
=begin
The sum of the squares of the first ten natural numbers is,

12 + 22 + ... + 102 = 385
The square of the sum of the first ten natural numbers is,

(1 + 2 + ... + 10)2 = 552 = 3025
Hence the difference between the sum of the squares of the first ten natural numbers and the square of the sum is 3025  385 = 2640.

Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.

=end

def get_sums_of_squares(number)
  
  squares = []
  result = 0
  
  range = Range.new(0,number)
  
  range.each{|number|
    squares << number**2
  }
  
  for @i in 0..squares.length-1 do
    result += squares[@i]
  end
  
  return result
  
  
end

def get_square_of_sums(number)
  
  sums = 0
  range = Range.new(0,number)
  
  range.each{|number|
    sums += number
  }
  
  return sums**2
  
end

sum_of_squares = get_sums_of_squares(100)
square_of_sums = get_square_of_sums(100)

# difference between sum of squares and square of sums is

puts (square_of_sums - sum_of_squares).to_s

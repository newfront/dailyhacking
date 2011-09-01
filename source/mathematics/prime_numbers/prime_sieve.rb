#!/usr/bin/env ruby

# Primary Numbers using Number Theory
# Sieve of Eratosthenese

# Using List
# Fastest
def prime_sieve(limit)
  
  limitn = limit+1
  primes = []
  
  # Fill in prime truth table
  for i in 0..limitn do
    primes[i] = true
  end
  
  primes[0] = false
  primes[1] = false
  
  primes.each_with_index{|prime,i|
    unless i < 2
      range = Range.new(i*i,limitn)
      range.step(i) {|index| primes[index] = false}
    end
  }
  
  true_primes = []
  primes.each_with_index{|value,i|
    true_primes << i if value == true
  }
  
  return true_primes
  
end

# Slower
def prime_sieve_hash(limit)
  limitn = limit+1
  primes = {}
  
  #populate hash with num:true
  (2..limitn).each{|val|
    primes[val] = true
  }
  
  # iterate through primes dictionary
  primes.each{|k,v|
    # we know that for every number (starting with 2)
    # that every factor of 2 upto the limitn, will not be a prime number
    range = Range.new(k*k,limitn)
    range.step(k) {|index| primes[index] = false }
  }
  
  # create primes container
  true_prime = []
  
  # collect prime
  primes.each{|k,v|
    true_prime << k if v === true
  }
  
  return true_prime
  
end

# Traditional Brute Force Prime Number Generator

def brute_force_primes(limit)
  
  primes = []
  complexity = 0
  # we know that 0,1 can't be prime
  # start at 2 and create a Range upto the limit
  (2..limit).each{|number|
    complexity += 1
    is_prime = true
    
    # any number is divisible by 1
    # so start at 2
    (2..number).each{|n|
      complexity += 1
      # ensure the number being tested is not the number in the loop
      unless number == n
        # continue unless the local loop value of n is a factor of number
        unless number % n != 0
          is_prime = false
          break
        end
      end
    }
    
    primes << number if is_prime
  }
  puts "O(n**2): #{(limit**2).to_s}"
  puts "Complexity: #{complexity.to_s}"
  return primes
  
end

def benchmark &block
  tstart = Time.now
  block.call
  tend = Time.now
  puts "Running Time: #{(tend.to_f - tstart.to_f).to_s}"
end

p = prime_sieve(2000)
puts p.inspect

primes = prime_sieve_hash(2000)
puts primes.inspect

primes2 = brute_force_primes(2000)
puts primes2.inspect

puts "\n\n\n"
puts "PRIMES SIEVE: "
benchmark{ prime_sieve(900000) }

puts "\n\n\n"
puts "PRIMES SIEVE HASH: "
benchmark{ prime_sieve_hash(265000) }

puts "\n\n\n"
puts "BRUTE FORCE: "
benchmark{ brute_force_primes(16200) }

#!/usr/bin/ruby

# prime number generator

@primes = []

def benchmark(&block)
  start_benchmark = Time.now
  yield
  end_benchmark = Time.now
  t = end_benchmark - start_benchmark
  puts "\nBenchmark: %f" % t
end

def gather_primes_to(num,return_value=true)
  
	# prime numbers are only divisible by 1 and themselves
	for @i in 1..(num) do
	  test_prime = check_for_prime(@i,num)
	  @primes << test_prime if !test_prime.nil?
	end
  
  if return_value
    return @primes
  else
    puts "\nPRIMES:\n#{@primes.inspect}"
	end
	
end

def check_for_prime(current,total)
  
  divisible_by_self = false
  divisible_by_one  = false
  divisible_by_none_other = true

  for j in (1..total) do
    if (current.to_f % j.to_f) == 0
      if j == 1
	      divisible_by_one = true
	    elsif j == current && current != 1
	      divisible_by_self = true
	    else
        divisible_by_none_other = false
      end
    end
  end

  # prime numbers are only divisible by 1 and themselves, so @divisible_by_none_other.should == true
  if divisible_by_self == true && divisible_by_one == true && divisible_by_none_other == true
    #@primes << current
    return current
  else
    return nil
  end
  
end

# get primes
#primes = gather_primes_to(500,true)
#puts "\nPRIMES:\n#{@primes.inspect}"

benchmark { gather_primes_to(500,false) }
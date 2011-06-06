#!/usr/bin/ruby

# prime number generator

@args = ARGV if !ARGV.nil?
@start = @args[0].to_i
@limit = @args[1].to_i

puts "Start #{@start.to_s} - LIMIT #{@limit.to_s}"

@primes = []

def benchmark(&block)
  start_benchmark = Time.now
  yield
  end_benchmark = Time.now
  t = end_benchmark - start_benchmark
  puts "\nBenchmark: %f" % t
end

def gather_primes(start,limit,return_value=true)
	# prime numbers are only divisible by 1 and themselves
	for @i in start..(limit) do
	  test_prime = check_for_prime(@i,limit)
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
#primes = gather_primes(50,500,true)
#puts "\nPRIMES:\n#{@primes.inspect}"

#@cap = 600851475143

if !@limit.nil?
  @cap = @limit
else
  @cap = 600851475143
end

if !@start.nil?
  @current = @start
else
  @current = 0
end

@threads = 0
@slices = 100

# loop (do, while) !
begin
  if @current <= @cap
    last = @current
    @current += @slices 
    @threads += 1
    puts "Current: #{@current.to_s}\n"
    puts "Primes: #{@primes.size.to_s}\n"
    benchmark { gather_primes(last,@current,false) }
    puts "Ran #{@threads} Times"
  end
end while @current < @cap

#benchmark { gather_primes_to(600851475143,false) }

#!/usr/bin/ruby
# PROBLEM 3 - PROJECT EULER

# grab csv file into Array chunks
File.open(File.dirname(__FILE__)+"/primes_to_750000.csv") do |f|
  @f = f.readlines
end

# strip white spaces
@primes = @f[0].split(',')
@primes.collect! do |n|
  n.gsub(/ /,'').to_i
end
puts @primes.inspect
@count = 0

# grab results and return to calling method
def run_recursive_loop &block
  results = yield
  return results
end

# main logic, tests for prime factors
def divide_and_find_prime_results(start_number,info_set)
  @next_results = []
  @factors = []
  # try to divide start_number by all members of info_set
  info_set.each {|prime| 
    @tmp_result = (start_number.to_f/prime.to_f)
    #puts "START NUMBER: #{start_number.to_s} / PRIME: #{prime.to_s} #{@tmp_result.to_s}"
    if (@tmp_result % 2) == 1
      #puts "FINALLY: #{prime.to_s}"
      @next_results << @tmp_result
      @factors << prime
    end
  }
  @count += 1
  return {"set"=>@next_results,"prime_factors"=>@factors}  
end

# used to display information on each set of tests against the target composite number
def run_til_none_left_to_run(test_number, start_set)
  r = run_recursive_loop { divide_and_find_prime_results(test_number,start_set) }
  puts "#{@count.to_s} Wave \n(TEST_NUMBER: #{test_number.to_s}\nRESULTS SET: #{r['set'].inspect}\nPrime Factors: #{r['prime_factors'].inspect}"
end

@cap = 600851475143 #13195
run_til_none_left_to_run(@cap,@primes)
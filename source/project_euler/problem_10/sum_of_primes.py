"""
Implemented using the Sieve of Eratosthenese algorithm
- assumption. Starting with the number 2, any multiple of 2 is not a prime number.

for primes upto 120
at 2, 2 removes 4,6,8,10,12,14,16,18,20,22,24,26,28....120 (basically cut the search in half)
by the time you get to 11, in your loop, all numbers are primes

"""

def primes_sieve(limit):
    limitn = limit+1
    primes = dict()
    # setup initial True set, start with 2 as it is first prime number
    for i in range(2, limitn): primes[i] = True
    # iterate through primes by i
    for i in primes:
      for f in range(i*i,limitn, i):
        #print("FACTOR FOR "+str(i)+" - "+str(f))
        primes[f] = False
    return [i for i in primes if primes[i]==True]

# Calculate the sum of the primes up to 2 million
print(str(sum(primes_sieve(2000000))))
# Find the nth prime number

primes = []

def compute_primes_to(num):
  if len(primes) == 0:
    current = 2
  else:
    current = primes[-1]+1
    
  breakpoint = len(primes) + num
  
  while True:
    if is_prime(current):
      primes.append(current)
    current += 1
    if len(primes) >= breakpoint:
      break
      
  return primes
  
def get_prime_at(num):
  if len(primes) >= num:
    return primes[num-1]
  else:
    return "primes haven't been computed to this point"

def size_of_primes():
  return len(primes)
  
def is_prime(num):
  prime = True
  for j in range(1,num):
    if j == num and num % j == 0:
      print("meets divisible by self criteria")
    if j != 1 and j != num and num % j == 0:
      prime = False
      break
  if prime:
    return True
  else:
    return False
    
# compute primes to n
# show the value of prime at n

#compute_primes_to(1000)
#print(str(get_prime_at(1000)))
# Find the greatest product of five consecutive digists in the 1000-digit number

number_products = {}

big_number = 7316717653133062491922511967442657474235534919493496983520312774506326239578318016984801869478851843858615607891129494954595017379583319528532088055111254069874715852386305071569329096329522744304355766896648950445244523161731856403098711121722383113622298934233803081353362766142828064444866452387493035890729629049156044077239071381051585930796086670172427121883998797908792274921901699720888093776657273330010533678812202354218097512545405947522435258490771167055601360483958644670632441572215539753697817977846174064955149290862569321978468622482839722413756570560574902614079729686524145351004748216637048440319989000889524345065854122758866688116427171479924442928230863465674813919123162824586178664583591245665294765456828489128831426076900422421902267105562632111110937054421750694165896040807198403850962455444362981230987879927244284909188845801561660979191338754992005240636899125607176060588611646710940507754100225698315520005593572972571636269561882670428252483600823257530420752963450

def calculate_product(num):
  product = 1
  for i in range(0,len(str(num))):
    product *= int(str(num)[i])
  number_products[num] = product
  #return product
  
# iterate over number, removing the first element of the number
# on each iteration, until we are left at only 4 elements in the numbers
# length. 

def iterate_over_number(num):
  step = 5
  str_num = str(num)
  
  # we only want to run this if our str(num) has a length of more than 5
  if len(str_num) > step:
    # generate product of chunk of first 5 numbers
    calculate_product(int(str_num[:5]))
    
    # ensure that the length of the str(num)-1 is greater than 5
    if len(str_num[1:]) > step:
      # call recursively with sequence (chop first num)
      iterate_over_number(str_num[1:])
    else:
      # we are at the len(str_num) == 5 condition
      # run calculate_product one last time
      calculate_product(int(str_num[1:]))

# iterate through dictionary of integer_sequence : integer_sequence_products
def find_highest_product(dict):
  maximus = []
  for items in dict.items():
    if len(maximus) == 0:
      # default state: set initial values
      maximus.append([items[0],items[1]])
    else:
      if items[1] > maximus[0][1]:
        # update max value
        maximus[0] = [items[0],items[1]]
  return maximus

iterate_over_number(big_number)
max_product = find_highest_product(number_products)
print("Max Product of 5 sequential numbers in 1000 digit number: (sequence of numbers): "+ str(max_product[0][0]) +" (sequence product): "+ str(max_product[0][1]))
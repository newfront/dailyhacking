"""
A Pythagorean triplet is a set of three natural numbers, a  b  c, for which,
a2 + b2 = c2

For example, 3**2 + 4**2 = 9 + 16 = 25 = 5**2
"""
import shelve

class Triplet:
  
  def __init__(self,a,b,c,p):
    self.a = a
    self.b = b
    self.c = c
    self.p = p

from math import sqrt

squares = {}

# [{"a"=num,"b"=num,"c"=num,"product"=num}]


# Need to pre-compute hash of squares
def compute_squares_upto(num):
  for i in range(1,num+1):
    squares[i] = i**2
  return squares
  
# pre-compute triplets
def compute_triplets(start,num):
  triplets = shelve.open('triplets-shelve')
  for i in range(start,num+start):
    result = get_triplet_for(i)
    if result != 0 and result[2][0] % 1 == 0:
      a = result[0][0]
      b = result[1][0]
      c = result[2][0]
      p = a + b + c
      print(str(p))
      if p % 1 == 0:
        t = Triplet(a,b,int(c),int(p))
        print(t)
        triplets[str(int(p))] = t
  triplets.close()

def view_triplets():
  db = shelve.open('triplets-shelve')
  for item in db:
    print(db[item].p)
  db.close()

# a**2 + b**2 = num
def get_triplet_for(num):
  
  # 3**2 + 4**2 = 9 + 16 = 25 = 5**2
  #if sqrt(num) % 2 != 0 or sqrt(num) % 2 != 1:
    #return 0
  for i in squares.items():
    for j in squares.items():
      if (i[1] + j[1]) == num:
        print("triplet:"+str(i[1])+"+"+str(j[1])+"="+str(num))
        return [i,j,(sqrt(num),num)]
  return 0

# test if a+b+c = num
def is_triplet(a,b,c):
  if a + b == c:
    return True
  else:
    return False
    
# a**2 + b**2 = c**2 where a+b+c = 1000
def find_triplet_for(num):
  if num in triplets:
    return triplets[num]
  else:
    print("better luck next time")
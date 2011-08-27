"""

a**2 + b**2 = c**2
where a < b < c

"""
ppt = {}

def generate_ppt(num):
  for x in range(1,num):
    for y in range(x+1,num):
      for z in range(y+1,num):
        if (x**2) + (y**2) == z**2:
          p = x+y+z
          ppt[p] = {"a":x,"b":y,"c":z}
          
def generate_ppt2(num):
  
  for x in range(1,num):
    y = x+1
    z = y+1
    while z <= num:
      while z**2 < x**2 + y**2:
        z = z+1
      if z**2 == x**2 + y**2 and z <= num:
        p = x+y+z
        ppt[p] = {"a":x,"b":y,"c":z}
      y = y+1
  return ppt


def product(dict):
  result = 1
  for item in dict:
    result *= dict[item]
  return result

print(product(generate_ppt2(1000)[1000]))
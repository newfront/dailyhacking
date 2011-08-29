"""

O(n + d), where d is the number of inversions

"""
#list = [-1,6,3,2,1,7,9,8,10,12,11,8,4,5]
list = [-1,2,3,4,7,6,9,8,10,12,11,5,90,80,70,60,65,45,35,42]

def insertion_sort(list):
  complexity = 0
  d = 0
  n_squared = len(list) ** 2
  for i in range(1,len(list)):
    complexity += 1
  # start at 0, step = 2
    value = list[i]
    j = i - 1
    
    while j > 0:
      d += 1
      #complexity += 1
      value = list[j+1]
      comparison = list[j]
      # check list[j] > list[j+1]
      if list[j] > value: # if 3 > 2 [3,2]
        # if so, swap
        list[j+1] = list[j] # [2,2]
        list[j] = value # [2,3]
      else:
        # unless j - 1 = 0, continue while loop
        j = j - 1
        if j == 0:
          break
  print("inversions: "+str(d))
  #print("nsquared: "+str(n_squared))
  print("(complexity): "+str(complexity))
  print(str(int(((complexity + d) / n_squared)*100))+"% more efficient than n**2 ("+str(n_squared)+")")
  return list
  
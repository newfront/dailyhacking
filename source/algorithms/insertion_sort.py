"""

O(n log n), or O(n + d) where d is the number of inversions

"""
import math
#list = [-1,6,3,2,1,7,9,8,10,12,11,8,4,5]
list = [-1,2,5,4,8,7,6,9,8,10,12,11,5,90,80,70,60,65,45,35,42]

def insertion_sort(list):
  print("size of list: "+str(len(list)))
  
  for i in range(1,len(list)):
    
    # start at 0, step = 2
    value = list[i]
    j = i - 1
    
    while j > 0:
      
      value = list[j+1]
      # check list[j] > list[j+1]
      if list[j] > value: # if 3 > 2 [3,2]
        print("swap "+str(list[j])+" with "+str(value))
        # if so, swap
        list[j+1] = list[j] # [2,2]
        list[j] = value # [2,3]
      else:
        # unless j - 1 = 0, continue while loop
        j = j - 1
        if j == 0:
          break
          
  return list
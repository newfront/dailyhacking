"""

O(n log n), or O(n + d) where d is the number of inversions

"""
import math
#list = [-1,6,3,2,1,7,9,8,10,12,11,8,4,5]
list = [-1,2,5,4,8,7,6,9,8,10,12,11,5,90,80,70,60,65,45,35,42]

def insertion_sort(list):
  
  n = len(list)
  
  for i in range(1,n):
    # save value to be positioned
    value = list[i]
    pos = i
    
    while pos > 0 and value < list[pos - 1]:
      list[pos] = list[pos-1]
      pos -= 1
      
    list[pos] = value
    
  return list
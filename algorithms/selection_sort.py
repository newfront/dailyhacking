"""
Selection Sort
worst case : O(n**2)
best case : O(nlogn)
"""

list = [-1,7,4,9,5,2,6,3,19,90,2,1,900,1,3]

def sort(list):
  print("list size: "+str(len(list))+" list size ** 2: "+str(len(list)**2))
  
  for i in range(0,len(list)):
    
    imin = i
    
    for j in range(i+1,len(list)):
      if list[j] < list[imin]:
        imin = j
    if imin != i:
      tmp = list[i]
      list[i] = list[imin]
      list[imin] = tmp
  
  return list
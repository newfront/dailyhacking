

list = [-1,3,5,7,9,10,11,15,18,20,22,29,34]
list2 = [2,5,8,11,16,25,29,39]

def mergesort(listA, listB):
  
  new_list = []
  a = 0
  b = 0
  
  # merge two lists together until one is empty
  while a < len(listA) and b < len(listB):
    if listA[a] < listB[b]:
      new_list.append(listA[b])
      a += 1
    else:
      new_list.append(listB[b])
      b += 1
  
  # If listA contains more items, append them to new_list
  while a < len(listA):
    new_list.append(listA[a])
    a += 1
  
  # or if listB contains more items, append them to new_list
  while b < len(listB):
    new_list.append(listB[b])
    b += 1
  
  return new_list
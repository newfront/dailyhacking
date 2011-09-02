# merge sort in python

list = [1,3,4,5,9,10]
list2 = [2,5,6,11,12,15]
merged = []

def mergesort(l1,l2):
  print(l1)
  print(l2)
  if len(l1) == 1 or len(l2) == 1:
    print("we are at the end")
    # we are at the end, test manually and return list
    if len(l1) == 1:
      if l1[0] > l2[0]:
        merged.append(l2[0])
        merged.append(l1[0])
        if len(l2[1:]) >= 1:
          merged.extend(l2[1:])
      else:
        merged.append(l1[0])
        merged.append(l2[0])
        if len(l2[1:]) >= 1:
          merged.extend(l2[1:])
    else:
      if l1[0] > l2[0]:
        merged.append(l2[0])
        merged.append(l1[0])
        if len(l1[1:]) >= 1:
          merged.extend(l1[1:])
      else:
        merged.append(l1[0])
        merged.append(l2[0])
        if len(l1[1:]) >= 1:
          merged.extend(l1[1:])
    return merged
  else:
    merge(l1,l2)

def merge(l1,l2):
  if l1[0] > l2[0]:
    print(str(l1[0]) +" is greater than "+ str(l2[0]))
    merged.append(l2[0])
    #merged.append(l1[0])
    mergesort(l1,l2[1:])
  elif l1[0] == l2[0]:
    print(str(l1[0]) +" is equal to "+ str(l2[0]))
    merged.append(l2[0])
    merged.append(l1[0])
    mergesort(l1[1:],l2[1:])
  else:
    print(str(l1[0]) +" is less than "+ str(l2[0]))
    merged.append(l1[0])
    #merged.append(l2[0])
    mergesort(l1[1:],l2)

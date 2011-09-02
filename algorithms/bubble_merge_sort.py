# bubble sort

alist = [-1,20,45,60,10,2,4,6,7,9]
alist2 = [-4,-5,30,2,3,70,90]
merged = []

def bubblesort(list):
  modified = 0
  
  for i in range(0,len(list)):
    try:
      tmp = list[i]
      tmp2 = list[i+1]
      if tmp > tmp2:
        a,b = list.index(tmp), list.index(tmp2)
        list[b],list[a] = list[a], list[b]
        modified = 1
    except:
      pass
  
  if modified:
    #print(list)
    bubblesort(list)
  #print(list)
  return list 

def mergesort(l1,l2):
  print(l1)
  print(l2)
  # if l1 has a length of 1 or l2 has a length of 1
  if len(l1) == 1 or len(l2) == 1:
    if len(l1) == 1:
      if l1[0] < l2[0]:
        merged.append(l1[0])
        merged.extend(l2)
      else:
        merged.append(l2[0])
        merged.append(l1[0])
        if len(l2[1:]) >= 1:
          merged.extend(l2[1:])
    elif len(l2) == 1:
      merged.append(l2[0])
      merged.extend(l1)
    return merged
  else:
    if l1[0] > l2[0]:
      print(str(l1[0]) + " > "+ str(l2[0]))
      merged.append(l2[0])
      #merged.append(l1[0])
      mergesort(l1,l2[1:])
    elif l1[0] == l2[0]:
      print(str(l1[0]) + " == "+ str(l2[0]))
      merged.append(l1[0])
      merged.append(l2[0])
      mergesort(l1[1:],l2[1:])
    else:
      print(str(l1[0]) + " < "+ str(l2[0]))
      merged.append(l1[0])
      #merged.append(l2[0])
      mergesort(l1[1:],l2)

  
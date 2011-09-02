"""
Counting Sort
1. create a histogram of elements in the list(s)
2. rebuild array in sorted order based on histogram
"""

list = [-1,3,2,1,9,10,12,14,16,90,11,8,7,6,4]
list2 = [2,8,5,4,7,10,23,45,20,19,7,5,18,90]

def sort(l1):
  
  inputs = {}
  
  # create count histogram
  for i in l1:
    #print(i)
    if len(inputs) < 1:
      inputs[i] = 1
    else:
      if i in inputs:
        inputs[i] += 1
      else:
        inputs[i] = 1
  
  #print(inputs)
  
  outputs = []
  
  # build base array
  for j in inputs:
    outputs.append(j)
  
  # sort base array
  for i in range(0,len(outputs)):
    imin = i
    
    for j in range(i+1,len(outputs)):
      if outputs[j] < outputs[imin]:
        imin = j
    if imin != i:
      tmp = outputs[i]
      outputs[i] = outputs[imin]
      outputs[imin] = tmp
  
  final = []
  
  # add elements by range of occurences
  for i in range(0,len(outputs)):
    #print(outputs[i])
    #print(inputs[outputs[i]])
    chunk = []
    for j in range(0,inputs[outputs[i]]):
      chunk.append(outputs[i])
    final.extend(chunk)
  
  return final

# Histogram based mergesort

def sort2(l1,l2):
  inputs = {}
  
  # create count histogram
  for i in l1:
    #print(i)
    if len(inputs) < 1:
      inputs[i] = 1
    else:
      if i in inputs:
        inputs[i] += 1
      else:
        inputs[i] = 1
  
  for i in l2:
    if i in inputs:
      inputs[i] += 1
    else:
      inputs[i] = 1
      #print(inputs)
      
  outputs = []
  
  # build base array
  for j in inputs:
    outputs.append(j)
    
  # sort base array
  for i in range(0,len(outputs)):
    imin = i
    
    for j in range(i+1,len(outputs)):
      if outputs[j] < outputs[imin]:
        imin = j
      
      if imin != i:
        tmp = outputs[i]
        outputs[i] = outputs[imin]
        outputs[imin] = tmp
  
  final = []
  # add elements by range of occurences
  for i in range(0,len(outputs)):
    #print(outputs[i])
    #print(inputs[outputs[i]])
    chunk = []
    for j in range(0,inputs[outputs[i]]):
      chunk.append(outputs[i])
    final.extend(chunk)
  
  return final
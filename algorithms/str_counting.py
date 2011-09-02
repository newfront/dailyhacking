"""
The counting algorithm is used to count the occurences of a character
in a string. This allows you to compare anagrams and strings themselves.
ex. Animal, lamina a=2,n=1,i=1,m=1
"""

def count_occurences(str):
  occurences = {}
  for char in str:
    if char in occurences:
      #print("already in set")
      occurences[char] = occurences[char] + 1
      #print(occurences[char])
    else:
      #print("add to dictionary")
      occurences[char] = 1
  return occurences
  
def is_matched(s1,s2):
  matched = True
  tests = 0
  
  s1_count_table = count_occurences(s1)
  
  for char in s2:
    tests += 1
    if char in s1_count_table and s1_count_table[char]>0:
      s1_count_table[char] -= 1
    else:
      matched = False
      break
  print(str(tests))
  return matched

#counting.is_matched("animal","lainam")
#!/usr/bin/env ruby

# merge sort

# unordered list of n elements

# john van neuman (beautiful mind)

# merge and sort two lists

# array.concat(array2).sort (simple ruby only lib method)

# merge complexity (n) linear

# Usage
# 1. bisect array
# 2. continue until we have singleton lists
# 3. combine sublists into single array

def merge_sort(unordered_list)
  p unordered_list
  
  if unordered_list.size < 2
    return unordered_list
  else
    middle = unordered_list.size / 2
    left = merge_sort(unordered_list[0,middle])
    right = merge_sort(unordered_list[middle,unordered_list.size])
    together = merge(left,right)
    puts "merged: #{together.inspect}"
    return together
  end 
end

def merge(left,right)
  
  result = []
  i,j = 0,0
  
  while i < left.size and j < right.size
    if left[i] <= right[j]
      result.push(left[i])
      #puts "(left) result: #{result.inspect}"
      i += 1
    else
      result.push(right[j])
      #puts "(right) result: #{result.inspect}"
      j+= 1
    end
  end
  
  while i < left.size
    result.push(left[i])
    #puts "(left base) result: #{result.inspect}"
    i += 1
  end
  
  while j < right.size
    result.push(right[j])
    #puts "(right base) result: #{result.inspect}"
    j += 1
  end
  return result
  
end

list = [1,20,50,21,10,19,2,3,4,5]

merge_sort(list)
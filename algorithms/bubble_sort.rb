#!/usr/bin/env ruby

# Bubble Sort Algorithm
=begin
Bubble Sort is a simple well-known sorting algorithm.
Rarely used in practice, but in the O(n)**2 (Big Oh) family of sorting algorithms
* Note: This is inefficient for sorting large data sets
=end

unsorted_list = [5,1,12,-5,16]

def bubble_sort(list)
  swap = false
  
  # iterate through list, if element > next element, swap, and test again
  
  for @i in 0..list.size do
    # test first,second
    if !list[@i+1].nil? && !list[@i].nil?
      if list[@i] > list[@i+1]
        tmp = list[@i]
        list[@i] = list[@i+1]
        list[@i+1] = tmp
        swap = true
      end
    end
  end
  
  bubble_sort(list) if swap
  
  return list
end

sorted_list = bubble_sort(unsorted_list)
puts sorted_list.inspect
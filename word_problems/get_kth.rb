#!/usr/bin/env ruby

=begin
Create a method that will take two sorted arrays and retrieve the kth largest number (result as comparison of the two sorted arrays) in log of n time.
=end

@arr_one = [1,4,9,21,34,65,98,200,400,1000]
@arr_two = [2,10,12,16,18,22,44,90,180,360,720,1080]

def binsearch(a,b)
 # grab length of a,b
 length = a.size
 length = (a.size + b.size) / 2 if a.size != b.size
 # split the arrays in half, compare the values at a_a[a_a.size-1] a_b[a_b.size-1]
end

binsearch(@arr_one, @arr_two)

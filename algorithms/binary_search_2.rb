#!/usr/bin/env ruby

=begin
 Binary Search algorithm in Ruby
=end

def rank(key, list)
    lo = 0
    hi = list.size
    count = 0
    while lo <= hi
        count += 1
        mid = lo + (hi - lo) / 2
        if key < list[mid]
            hi = mid-1
        elsif key > list[mid]
            lo = mid+1
        else
            puts "found match #{count.to_s}"
            return list[mid]
        end
    end
    return -1
end

def do_binary_search(key, list)
    res = rank(key, list)
    puts res
end

def get_search_group
    args = []
    (1..20000000).each{|n| args << rand(3000)}
    args = args.sort
end

do_binary_search(50, get_search_group)

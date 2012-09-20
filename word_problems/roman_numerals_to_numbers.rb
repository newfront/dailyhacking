#!/usr/bin/env ruby

=begin
Given a string representing roman numeral, find and return its numeric value. e.g. XXIV = 24 and so on.
# MCMXLIV = 1000 + (1000 − 100) + (50 − 10) + (5 − 1) = 1944
=end

@map = {"I" => 1, "V" => 5, "X" => 10, "L" => 50, "C" => 100, "D" => 500, "M" => 1000}

def roman_to_decimal (num_str)
  i=0
  length = num_str.length
  total = 0
  # When smaller values precede larger values, the smaller values are subtracted from the larger values
  while length > i do
    unless num_str[i+1].nil?
      # check next value (is it greater than)
      if @map[num_str[i+1]] > @map[num_str[i]]
        total += (@map[num_str[i+1]] - @map[num_str[i]])
        i += 1
      else
        total += @map[num_str[i]]
      end
    else
      total += @map[num_str[i]]
    end
    i += 1
  end
  puts "total: #{total.to_s}"
end

roman_to_decimal("MCMXLIV")
#!/usr/bin/env ruby

=begin
The counting algorithm is used to count the occurences of a character
in a string. This allows you to compare anagrams and strings themselves.
ex. Animal, lamina a=2,n=1,i=1,m=1
=end

def count_occurences(str)
  occurences = {}
  str.each_char{|char|
    if occurences.has_key? char
      occurences[char] += 1
    else
      occurences.store(char,1)
    end
  }
  return occurences
end

def is_match(s1,s2)
  matched = true
  # create occurences table for characters in s1, s2
  
  # grab occurences from str1
  s1_count_table = count_occurences(s1)
  #{"a"=>2, "n"=>1, "i"=>1, "m"=>1, "l"=>1}
  
  # search in n time
  s2.each_char{|char|
    puts "#{char}"
    if s1_count_table.has_key? char
      puts "#{char}:#{s1_count_table[char]}"
      s1_count_table[char] = s1_count_table[char] - 1 
      puts "#{char}:#{s1_count_table[char]}"
    else
      matched = false
    end
  }
  return matched
end

str = "animal"
str2 = "lamina"

puts is_match(str,str2)
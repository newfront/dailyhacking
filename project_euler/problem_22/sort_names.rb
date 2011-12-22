#!/usr/bin/env ruby

=begin
Using names.txt (right click and 'Save Link/Target As...'), a 46K text file containing over five-thousand first names, begin by sorting it into alphabetical order. Then working out the alphabetical value for each name, multiply this value by its alphabetical position in the list to obtain a name score.
For example, when the list is sorted into alphabetical order, COLIN, which is worth 3 + 15 + 12 + 9 + 14 = 53, is the 938th name in the list. So, COLIN would obtain a score of 938  53 = 49714.
What is the total of all the name scores in the file?
=end
file = "/path/to/names.txt"

@names = []
@names_index = {}
@alphabet = {}
("a".."z").each_with_index{|char,i|
  @alphabet[char] = i+1
}

puts @alphabet.inspect

File.open(file,'rb') do |f|
  f.each_line{|line|
    line.split(",").each{|word|
      @names << word.downcase.strip.gsub("\"","")
    }
  }
end

@names = @names.sort

@names.each_with_index{|name,i|
  # number in the list is human friendly, so i+1
  @names_index[name] = i+1
}

target = "COLIN"

def char_sum(word)
  sum = 0
  word.each_char{|c|
    sum += @alphabet[c]
  }
  return sum
end

def name_in_list(name)
  return @names_index[name]
end

def get_each_name_score(list)
  sum = 0
  list.each{|name|
    sum += char_sum(name.downcase) * name_in_list(name.downcase)
  }
  return sum
end

puts get_each_name_score(@names)
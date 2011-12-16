#!/usr/bin/env ruby
require 'pp'

# take the file from std_in (twl06.txt)
#Your program will be given a list of accepted words and run on one wall post at a time. 
#For each word W in the post, you must find word W' from the list of accepted words 
#such that the number of changes from W to W' is minimized. 
#It is possible that W is already W' and thus the number of changes necessary is zero. 
#A change is defined as replacing a single letter with another letter, adding a letter in any position, 
#or removing a letter from any position. The total score for the wall post is the minimum number of changes 
#necessary to make all words in the post acceptable. 

$stdin = ARGV
$wall_post = $stdin[0]
@acceptable_file = '/var/tmp/twl06.txt'
$words_map = {}

# $letters_index["a"][1] = [], $letters_index["a"][2] = []
$letters_index = {}

# ex: this = t=1,h=1,i=1,s=1
# 
def count_characters(word)
  @char_map = {}
  puts "word is: #{word.to_s}"
  word.each_char {|char| 
    unless @char_map.has_key?(char)
      @char_map[char] = 1
    else
      @char_map[char] += 1
    end
  }
  puts @char_map.inspect
  puts
  return {"word" => word, "map" => @char_map}
end

#$words_map = {}


def add_to_words_index (word, map, index)
  puts word.inspect
  #puts map.inspect
  
  map.each{|k,v|
    puts "#{k.to_s}, #{v.to_s}"
    unless index.has_key?(k)
      index[k] = {} #index["a"] = {}
      index[k][v] = [] #index["a"][1] = []
      index[k][v] << word
    else
      unless index[k].has_key?(v)
        index[k][v] = []
      end
      index[k][v] << word
    end
  }
  
end

def get_acceptable_words(file)
  @acceptable_words = []
  File.open(file) do |f|
    f.each_line {|line|
      # is a single word per line
      @acceptable_words << line.downcase.strip
    }
  end
  return @acceptable_words
end

@acceptable_words = get_acceptable_words(@acceptable_file)

if !@acceptable_words.empty?
  @count = 0
  puts @count.to_s
  while @count < @acceptable_words.size do
    tmp = count_characters(@acceptable_words[@count])
    puts tmp.inspect
    add_to_words_index(tmp["word"], tmp["map"], $words_map)
    @count += 1
  end
  
  puts "words index"
  pp $words_map
  
else
  puts "error getting acceptable words"
end


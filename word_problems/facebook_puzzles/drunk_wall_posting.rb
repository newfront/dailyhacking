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
@acceptable_file = '/var/tmp/twl06.txt' #178691 words
$words_map = {}

# $letters_index["a"][1] = [], $letters_index["a"][2] = []
$letters_index = {}

# ex: this = t=1,h=1,i=1,s=1
# 
def count_characters(word)
  @char_map = {}
  #puts "word is: #{word.to_s}"
  word.each_char {|char| 
    unless @char_map.has_key?(char)
      @char_map[char] = 1
    else
      @char_map[char] += 1
    end
  }
  #puts @char_map.inspect
  #puts
  return {"word" => word, "map" => @char_map}
end

#$words_map = {}

$total_indexed_words = 0

def add_to_words_index (word, map, index)
  #puts word.inspect
  #puts map.inspect
  @words = 0
  map.each{|k,v|
    #puts "#{k.to_s}, #{v.to_s}"
    unless index.has_key?(k)
      index[k] = {} #index["a"] = {}
      index[k][v] = [] #index["a"][1] = []
      index[k][v] << word
      @words += 1
      (index[k]["index"] ||= {})
      index[k]["index"][v] = "#{word} "
    else
      unless index[k].has_key?(v)
        index[k][v] = []
        (index[k]["index"] ||= {})
      end
      index[k][v] << word
      (index[k]["index"][v] ||= "") << "#{word} "
      @words += 1
    end
  }
  $total_indexed_words += @words
  
end
# line by line method, no dual processes
def get_acceptable_words(file)
  @acceptable_words = []
  File.open(file) do |f|
    f.each_line {|line|
      # is a single word per line
      #@acceptable_words << line.downcase.strip
      tmp = count_characters(line.downcase.strip)
      #puts tmp.inspect
      add_to_words_index(tmp["word"], tmp["map"], $words_map)
    }
  end
  
  #puts $words_map.inspect
  return @acceptable_words
end

# two part, capture words, use divide and conquer approach
def get_acceptable_words_new(file)
  @words_buffer = []
  File.open(file) do |f|
    f.each_line {|line|
      # grab word, add 1000 words to each Thread to be processed
      # is a single word per line
      @words_buffer << line.downcase.strip
      if @words_buffer.size > 1000
        breakdown(@words_buffer)
        @words_buffer = []
      end
    }
  end
end

def breakdown(words_arr)
  
  Thread.new(words_arr){
    words_arr.each{|word|
      tmp = count_characters(word)
      add_to_words_index(tmp["word"], tmp["map"], $words_map)
    }
  }
end

def benchmark &block
  start = Time.now.to_f
  block.call()
  end_time = Time.now.to_f
  puts "running time of #{(end_time - start).to_s}"
  puts "total words in indexes: #{$total_indexed_words.to_s}"
  puts $words_map.inspect
  #puts $words_map.inspect
end

# using line by line method
# 9.58 seconds ( to slow....) with puts of the text blob
# 5.91 seconds ( to slow....) without seeing response or writting to file
# 5.28 seconds using Threads crunching 1000 words a thread
benchmark {get_acceptable_words(@acceptable_file)}

# logic
# use the index, and first count the characters in the word
# see if any words in our index contain all or most of these characters
#ex: tihs, this ( check words in index["t"][1], index["i"][1], index["h"][1], index["s"][1], and see what words exist accross all indexes


# usage
# ruby drunk_wall_posting.rb tihs sententcnes iss nout varrry goud

# check the word tihs
@check_word = "tihs"
mapping = count_characters(@check_word)
@results = {}
mapping["map"].each{|k,v|
  puts "check the index for $words_map[#{k.to_s}][#{v.to_s}]"
  # check against master list
  # push into @results hash ( word, count), each time the same word is entered its count goes up
  # see which word occures the most out of all the findings
  # that is what you need to test for
}

#!/usr/bin/env ruby

# if the numbers 1 to 5 are written out in words: one, two, three, four, five, then there are 3 + 3 + 5 + 4 + 4 = 19 letters.
# if all the numbers from 1 to 1000 inclusive were written out in words, how many letters would be used?

=begin
one ,two ,three ,four ,five ,six , seven, eight, nine

ten, eleven, twelve, thirteen

fourteen, fifteen, sixteen, seventeen, *eighteen, nineteen

twenty, ++(ex: twenty-five)

thirty, forty, fifty, sixty, seventy, eighty, ninety

one hundred, ++(ex: one hundred and twenty-five)

two hundred, three hundred, four hundred, five hundred, six hundred, seven hundred, eight hundred, nine hundred, one thousand
=end

# map number to string equivilant where we need to
@single = {1=>"one",2=>"two",3=>"three",4=>"four",5=>"five",6=>"six",7=>"seven",8=>"eight",9=>"nine"}
@unique = {11=>"eleven",12=>"twelve",13=>"thirteen",18=>"eighteen"}
@double = {10=>"ten",20=>"twenty",30=>"thirty",40=>"forty",50=>"fifty",60=>"sixty",70=>"seventy",80=>"eighty",90=>"ninety"}
@triple = "hundred"
@quad = "thousand"

def do_int_to_string_converstion(num)
  # capture original number for int comparisons
  word = ""
  @num_original = num
  @num_str = num.to_s
  @num_size = @num_str.size
  
  if @num_size === 4
    if @num_str[0] === "1"
      word += "one thousand"
      word += " " if @num_str[1] != "0"
      @num_str = @num_str[1,@num_str.size]
    end
    @num_size = @num_str.size
  end
  
  if @num_size === 3
    if @num_str[0] != "0"
      word += "#{@single[@num_str[0].to_i]} hundred"
      word += " and " if @num_str[1] != "0"
      @num_str = @num_str[1,@num_str.size]
      @num_size = @num_str.size
    else
      return word
    end
  end
  
  if @num_size < 3
    if @num_str[0] != "0"
      resp = get_int_to_word(@num_str, @num_size)
      word += resp if !resp.nil?
    elsif @num_size == 2 and @num_str[0] == "0"
      #puts "this is not octal! #{@num_str[1].to_s}"
      resp = get_int_to_word(@num_str[1],1)
      word += " and " + resp if !resp.nil?
    end
    return word
  end
  
end

def get_int_to_word(num, length)
  
  @word = []
  @tmp = num[0].to_i
  @tmp2 = num[1].to_i if length > 1
  
  if length == 1
    return @single[@tmp]
  elsif length == 2
    
    # 10,20,30,40,50,60,70,80,90
    return @double[num.to_i] if @double.has_key?(num.to_i)
    
    if num.to_i > 10 and num.to_i < 14
      return "eleven" if @tmp2 === 1
      return "twelve" if @tmp2 === 2
      return "thirteen" if @tmp2 === 3
    elsif num.to_i >= 14 and num.to_i < 20
      return "#{@single[@tmp2].to_s}teen" if @tmp2 != 8 and @tmp2 != 5
      return "eighteen" if @tmp2 === 8
      return "fifteen" if @tmp2 === 5
    elsif num.to_i >= 21
      ns = "#{@tmp.to_s}0"
      @word = @double[ns.to_i]
      @word += "-#{@single[@tmp2]}"
      return @word
    end
    
  end
  
end

def count_chars(word)
  word = word.gsub(" ","").gsub("-","")
  return word.size
end

# get the human friendly version of the integer value
#human_friendly_word = do_int_to_string_converstion(342) #23
#human_friendly_word = do_int_to_string_converstion(115) #20
#puts human_friendly_word
#puts "the word size of #{human_friendly_word} is #{count_chars(human_friendly_word).to_s}"


@count = 1
@total_chars = 0
while @count <= 1000
  word = do_int_to_string_converstion(@count)
  letters = count_chars(word)
  puts word + "(#{letters.to_s})"
  @total_chars += letters
  @count += 1
end

puts "total characters from one to one thousand inclusive: #{@total_chars}"

# write to text file to ensure correct spelling
# ruby int_to_human_friendly_string_counting.rb > /path/to/folder/integers_to_human_friendly.txt

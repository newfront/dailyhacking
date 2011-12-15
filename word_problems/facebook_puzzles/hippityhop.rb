#!/usr/bin/env ruby

$input = ARGV

# single positive number ( base 10 ) expressed as string
# may or may not be padded on either side
# may or may not be terminated by a single new line character

# kill padding and newline if it exists
$spnumber = $input[0].strip

def calculate_hippity_hop(number)
  
  1.upto(number.to_i){|num|
    if num % 3 == 0 and num % 5 == 0
      puts "Hop\n"
    elsif num % 5 == 0
      puts "Hophop\n"
    elsif num % 3 == 0
      puts "Hoppity\n"
    end
  }
  
end

calculate_hippity_hop($spnumber)
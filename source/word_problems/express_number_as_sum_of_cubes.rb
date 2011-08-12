#!/usr/bin/env ruby

=begin
Background: The mathematician G. H. Hardy was on his way to visit his collaborator S. Ramanujan who was in the hospital. 
Hardy remarked to Ramanujan that he traveled in a taxi cab with license plate 1729, which seemed a dull number.  
To this, Ramanujan replied that 1729 was a very interesting number,
it was the smallest number expressible as the sum of cubes of two numbers in two different ways. Indeed, 10x10x10 + 9x9x9 = 12x12x12 + 1x1x1 = 1729.

Problem: 
Given an arbitrary positive integer, how would you determine 
if it can be expressed as a sum of two cubes?
=end

number = rand(2000000)

@cube_sums = []
@cube_sums_variations = []
@cube_sums_map = {}
@cube_sums_variations_map = []


# calculate cube
def cube_sum(num)
  return (num*num*num)
end

# # generate cube sums to work with
def calculate_cube_sums(num)
  range = Range.new(0,num)
  range.each{|num|
    tmp = cube_sum(num)
    @cube_sums << tmp
    @cube_sums_map.store(tmp,num)
  }
  calculate_cube_sum_options(@cube_sums,@cube_sums_variations)
end

# pre-calculate all variations for cube_sums
def calculate_cube_sum_options(list,into_list)
  
  list.each{|first_num|
    list.each{|second_num|
      #unless into_list.include? (first_num + second_num)
        into_list << first_num + second_num 
        @cube_sums_variations_map << [[first_num,second_num]]
      #end
    }
  }
  return @cube_sum_variations
  
end

def show(list)
  puts list
end

def is_sum_of_cubes?(num)
  puts "TARGET: #{num.to_s}"
  is_sum_of_cubes = false
  cubes = []
  makes_cubes = []
  @cube_sums_variations.each_with_index{|value,i|
    #puts "value: #{value.to_s} at index: #{i.to_s} test against #{num.to_s}"
    if value == num
      puts "value: #{value.to_s} == #{num.to_s}"
      puts "sum of cubes: #{@cube_sums_variations_map[i][0].to_s}"
      cubes << @cube_sums_variations_map[i][0]
      
      puts @cube_sums_variations_map[i][0].length.to_s
      
      @cube_sums_variations_map[i][0].each {|number|
        puts "cube sums variation number: #{number.to_s}"
        # find what makes this cube
        if @cube_sums_map.has_key? (number)
          puts "look at the number, since it is in the sums map"
          puts @cube_sums_map[number].to_s
          makes_cubes << @cube_sums_map[number].to_s
        end
      }
      # @cube_sums_map
      is_sum_of_cubes = true
    end
  }
  if is_sum_of_cubes
    data = {}
    data[:cubes] = cubes
    data[:builds_cubes] = makes_cubes
    return data.to_s
  else
    return "no"
  end
end

# grab cube sums
calculate_cube_sums(200)
show(@cube_sums_variations)

puts is_sum_of_cubes? 1729
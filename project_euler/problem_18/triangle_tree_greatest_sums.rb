#!/usr/bin/env ruby
require 'pp'
=begin
 By starting at the top of the triangle below
 and moving to adjacent numbers on the row below, 
 the maximum total from top to bottom is 23. 
 
 row[0][0] = 3
 row[1][0] = 7
 row[1][1] = 4
 row[2][0] = 2
 row[2][1] = 4
 row[2][2] = 6
 row[3][0] = 8
 row[3][1] = 5
 row[3][2] = 9
 row[3][3] = 3
 
 best route is 3 -> 7 -> 4 -> 9 = 23
 
 has to be adjacent
 3 -> 7 -> 2 -> 8
 3 -> 7 -> 2 -> 5
 3 -> 7 -> 4 -> 5
 3 -> 7 -> 4 -> 9
 3 -> 4 -> 4 -> 5
 3 -> 4 -> 4 -> 9
 etc
 
=end

# row zero has 1 number
# row one has 2 numbers
# row two has 3 numbers
# row three has 4 numbers

@numbers = [3,7,4,2,4,6,8,5,9,3]
@tree = []

class Node
  attr_accessor :name, :value, :child_a, :child_b
  
  def initialize(params = {})
    self.name = params[:name] if params.has_key?(:name)
    self.value = params[:value] if params.has_key?(:value)
    self.child_a = params[:child_a] if params.has_key?(:ca)
    self.child_b = params[:child_b] if params.has_key?(:cb)
  end
  
  def get_children(type="all")
    case type
    when "a" then return self.child_a
    when "b" then return self.child_b
    else
      return {:a => self.child_a, :b => self.child_b}
    end
  end
  
  def has_children?
    unless self.child_a.nil? and self.child_b.nil?
      return true
    else
      return false
    end
  end
  
  def get_value
    return self.value
  end
  
  def child(child, type="a")
    if type === "a"
      self.child_a = child
    else
      self.child_b = child
    end
  end
  
end

#@a_node = Node.new({:name => "a node", :value => 3})
#@b_node = Node.new({:name => "b node", :value => 7})
#@c_node = Node.new({:name => "c node", :value => 4})

#@a_node.child(@b_node, "a")
#@a_node.child(@c_node, "b")

#if @a_node.has_children?
#  puts @a_node.get_children("a").value
#  puts @a_node.get_children("b").name
#end

#if @b_node.has_children?
#  puts "has them for sure"
#else
#  puts "no children"
#end


def array_to_tree(arr)
  @column = 0
  @rows = 1
  @insertions = 0
  @tree = []
  @nodes = {}
  arr.each {|num|
    
    @tree[@column] = [] if @tree[@column].nil? 
    @tree[@column] << num
    @nodes["#{@column.to_s}_#{num.to_s}"] = Node.new({:name => "#{num.to_s}_node", :value => num})
    @insertions += 1
    
    unless @insertions < @rows
      @column += 1
      @rows += 1
      @insertions = 0
    end
  }
  pp @nodes
  return {:tree => @tree, :nodes => @nodes}
end

vals = array_to_tree(@numbers)
@tree = vals[:tree]
@nodes = vals[:nodes]

# populate tree
def make_tree(tree, nodes)
  @parent = [] # will be parent
  @current = [] # will hold current branch
  @column = 0
  @rows = 1
  @insertions = 0
  @nodes = nodes
  
  @childs = ["a","b"]
  # tree -> a->b,c
  tree.each{|obj|
    @current_objs = obj.size
    if @current_objs === 1
      target = "#{@column.to_s}_#{obj[0].to_s}"
      @parent << @nodes[target]
    else
      
      @new_parents = []
      # children
      # max = 2
      # 0,1 (count+1)
      # count,count+1
      #puts @parent[0]
      puts "length of parent: #{@parent.size}"
      
      for @i in 0..@parent.size-1 do
        puts @column
        count = @count
        puts "count: #{@count.to_s}"
        first = "#{@column.to_s}_#{obj[@i].to_s}"
        last = "#{@column.to_s}_#{obj[@i+1].to_s}"
        
        @parent[@i].child(@nodes[first], "a")
        @parent[@i].child(@nodes[last], "b")
        
        unless @new_parents.include? @nodes[first]
          @new_parents << @nodes[first]
        end
        
        unless @new_parents.include? @nodes[last]
          @new_parents << @nodes[last]
        end
      end
      
      @parent = @new_parents
      puts "parent node shift"
      puts "-----------------"
      #pp @parent
    end
    puts "-----------"
    @column += 1
  }
  #pp @nodes
  return @nodes
end

@nodes = make_tree(@tree, @nodes)
@values = {}
@prior = 0
@current = 0
@max = 0
@level_max = 0

@nodes.each{|key, node|
  @skip = false
  puts key
  puts "---------"
  @level = key.split("_")
  puts "Level: #{@level[0].to_s}"
  
  puts "#{@level[0].to_s} - #{@prior.to_s}"
  
  if @level[0] != @prior
    @prior = @level[0]
    puts "at new level"
    puts "max from last level: #{@max.to_s}"
    @level_max = @max
    @max = 0
  end
  
  if @level_max != 0
    if node.value != @level_max
      @skip = true
    end
  end
  
  if !@skip
    unless !node.has_children?
      vals = {}
      vals["parent"] = node.value
      vals["ca"] = node.get_children("a").value
      vals["cb"] = node.get_children("b").value
      puts vals["parent"]
      puts vals["ca"]
      puts vals["cb"]
      puts "----------------"
      sum = vals["parent"] + vals["ca"]
      sum2 = vals["parent"] + vals["cb"]
    
      if sum > sum2
        @last = vals["ca"]
        @values[node.name] = {:values => [vals["parent"],vals["ca"]], :sum => sum}
        if @max === 0
          @max = vals["ca"]
        elsif sum > @max
          @max = vals["ca"]
        end
      
      elsif sum == sum2
        @last = vals["ca"]
        @values[node.name] = {:values => [vals["parent"],vals["ca"]], :sum => sum}
        if @max === 0
          @max = vals["ca"]
        elsif sum > @max
          @max = vals["ca"]
        end
      else
        @last = vals["cb"]
        @values[node.name] = {:values => [vals["parent"],vals["cb"]], :sum => sum2}
        if @max === 0
          @max = vals["cb"]
        elsif sum2 > @max
          @max = vals["cb"]
        end
      end
    else
      puts "skipping"
    end
    puts "---------"
    
  end
  #puts node.inspect
  #puts node.has_children?
  #puts "-----------"
}

# show the best route
pp @values
@best_path = ""
@unique = []
@sum = 0
@values.each{|k,v|
  #puts v[:values].inspect
  @best_path << "(#{v[:values][0].to_s} -> #{v[:values][1].to_s}) "
  
  @unique << v[:values][0] unless @unique.include? v[:values][0] 
  @unique << v[:values][1] unless @unique.include? v[:values][1] 
}

pp @unique

puts "best path is: #{@best_path}"
@unique.each{|val|
  @sum += val
}
puts "sum of path is: #{@sum.to_s}"


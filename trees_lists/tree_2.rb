#!/usr/bin/env ruby

class Node
  
  attr_accessor :value, :right, :left
  
  def initialize(params={})
    self.value = params[:value] unless params[:value].nil?
    self.right = params[:right] unless params[:right].nil?
    self.left = params[:left] unless params[:left].nil?
  end
  
  def has_children?
    return true unless self.right.nil? or self.left.nil?
    return false
  end

end

# 3, 7, 4, 2, 4, 6, 8, 5, 9, 3

a_node = Node.new({:value => 3})

b_node = Node.new({:value => 7})
c_node = Node.new({:value => 4})

d_node = Node.new({:value => 2})
e_node = Node.new({:value => 4})

f_node = Node.new({:value => 6})

g_node = Node.new({:value => 8})
h_node = Node.new({:value => 5})
i_node = Node.new({:value => 9})
j_node = Node.new({:value => 3})

# a -> b,c
a_node.left = b_node
a_node.right = c_node

b_node.left = d_node
b_node.right = e_node

c_node.left = e_node
c_node.right = f_node

d_node.left = g_node
d_node.right = h_node

e_node.left = h_node
e_node.right = i_node

f_node.left = i_node
f_node.right = j_node

# count sums from top to bottom
def get_sums(node, sum=0, chain="")
  sum += node.value
  chain += "#{node.value.to_s} "
  unless !node.has_children?
    # left, right
    get_sums(node.left, sum, chain) #3
    get_sums(node.right, sum, chain) #3
  else
    puts "node has no children"
    puts "chain: #{chain}"
    puts "sum: #{sum.to_s}"
  end
end

get_sums(a_node,0,'')
#!/usr/bin/env ruby
require 'pp'

class Node
	
	attr_accessor :child_a, :child_b, :value, :level, :max
	
	def initialize(params={})
	  # this node has "a" child
		self.child_a = params[:child_a] if !params[:child_a].nil?
		# this node has "b" child
		self.child_b = params[:child_b] if !params[:child_b].nil?
		# value is the value / distance for the node
		self.value = params[:value] if !params[:value].nil?
		# level means the row in the tree
		self.level = params[:level] if !params[:level].nil?
		# max means this is the largest value in the level
		self.max = !params[:max].nil? ? params[:max] : false 
	end
	
	# check if the Node has children
	def has_children?
	  return true unless self.child_a.nil? || self.child_b.nil? 
	end
	
	# add a Child Node to the Node
	def child(node, type="a")
	  return "Error. node's can only be of type Node" unless node.is_a? Node
	  self.child_a = node if type === "a"
	  self.child_b = node if type === "b"
	end

end

#@nodes = [75,95,64,17,47,82,18,35,87,10,20,4,82,47,65,19,1,23,75,3,34]
@nodes = [75,95,64,17,47,82,18,35,87,10,20,4,82,47,65,19,1,23,75,3,34,88,02,77,73,07,63,67,99,65,04,28,06,16,70,92,41,41,26,56,83,40,80,70,33,41,48,72,33,47,32,37,16,94,29,53,71,44,65,25,43,91,52,97,51,14,70,11,33,28,77,73,17,78,39,68,17,57,91,71,52,38,17,14,91,43,58,50,27,29,48,63,66,4,68,89,53,67,30,73,16,69,87,40,31,4,62,98,27,23,9,70,98,73,93,38,53,60,4,23]

def create_nodes_maxes_levels(values_arr)
  
  tree = {}
  row_max = {}
  nodes = []
  
  last = nil
  column = 1
  inserted = 0
  max = 0
  
  values_arr.each{|node|
    
    if column === inserted
      column += 1
      inserted = 0
      max = 0
    end
    
    # create a new Node
    nodes << Node.new({:value => node})
    
    # calculate the max node value per row
    unless max > 0
      max = node
    else
      max = node unless max > node
    end
    
    # set the row max
    row_max[column] = max
    
    (tree[column] ||= [])
    tree[column] << node
    # increment
    inserted += 1
  }
  return {:tree => tree, :maxes => row_max, :nodes => nodes}
end

@tree = create_nodes_maxes_levels(@nodes)
pp @tree

# generate the tree structure from the @tree[:nodes]
def generate_tree_structure(tree, level_maxes, nodes)
  gen_nodes = 0
  # iterate over the tree structure ( bfs )
  # each node can have two children or no children
  # each node can be a max for the row ( this is a pre-emptive breadcrumb for figuring out the best path through the tree)
  tree.each{|level|
    # tree have levels
    # levels have Array of values to be mapped to nodes
  }
end

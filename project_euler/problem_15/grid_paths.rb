#!/usr/bin/env ruby

=begin
Starting at the left corner of a 2x2 grid, how many
paths are there to the bottom right corner
=end

class Vertex
  
  attr_accessor :value, :aNode, :bNode, :visited
  
  def initialize(params={})
    self.value = params[:value] unless params[:value].nil?
    self.visited = false
  end
  
  def neighbor(node, type="a")
    self.aNode = node unless type != "a"
    self.bNode = node unless type != "b"
  end
  
  def has_node?(type="a")
    if type == "a"
      return true unless self.aNode.nil?
    elsif type == "b"
      return true unless self.bNode.nil?
    end
    return false
  end
  
end

# create a 20 by 20 grid of vertexes
@verticies = {}
def create_verticies(columns, rows)
  verticies = {}
  0.upto(columns-1).each{|col|
    0.upto(rows-1).each{|row|
      tmp = "#{col.to_s}_#{row.to_s}"
      verticies[tmp] = Vertex.new({:value => tmp})
    }
  }
  return verticies
end

def create_edges(vertices)
  @rows = 20
  @columns = 20
  @count = 0
  @level = 0
  @verticies.each{|k,v|
    # 0->01, 0 -> 11
    puts v.value
    a_child = "#{(@level).to_s}_#{(@count+1).to_s}"
    puts "a_child -> #{a_child}"
    
    b_child = "#{(@level+1).to_s}_#{@count.to_s}"
    puts "b_child -> #{b_child}"
    #puts @verticies[a_child].value
    if @verticies.has_key?(a_child)
      v.neighbor(@verticies[a_child],"a")
    end
    #puts @verticies[b_child].value
    if @verticies.has_key?(b_child)
      v.neighbor(@verticies[b_child],"b")
    end
    
    #puts @count
    #puts @level
    @count += 1
    if @count > @columns-1
      @count = 0
      @level += 1
    end
  }
end

@verticies = create_verticies(20,20)

create_edges(@verticies)

puts @verticies["0_0"].has_node?("a")
puts @verticies["0_0"].has_node?("b")


@origin_node = nil
@paths = 0
@count = 0

def follow_tree(node,path)
  if @count < 150000
    @count += 1
  else
    sleep(1)
    @count = 0
  end
  
  @origin_node = node unless !@origin_node.nil?
  
  unless path == ""
    path += "-> #{node.value.to_s}"
  else
    path += node.value
  end
  
  visiting = false
  
  unless !node.has_node?("a")
      follow_tree(node.aNode, path)
      visiting = true
  end
  
  unless !node.has_node?("b")
      follow_tree(node.bNode, path)
      visiting = true
  end
  
  unless visiting
    @paths += 1
    puts @paths
  end
  
end

puts "---------------"
response = follow_tree(@verticies["0_0"],'')
puts "---------------"

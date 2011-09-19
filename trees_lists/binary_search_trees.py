class bin_tree_node:
  
  def __init__(self,data):
    self.data = data
    self.left = None
    self.right = None

a_node = bin_tree_node("A")
b_node = bin_tree_node("B") #A
c_node = bin_tree_node("C") #A
d_node = bin_tree_node("D") #B
e_node = bin_tree_node("E") #B
f_node = bin_tree_node("F") #C
g_node = bin_tree_node("G") #C
h_node = bin_tree_node("H") #E
i_node = bin_tree_node("I") #G

a_node.left = b_node
a_node.right = c_node

b_node.left = d_node
b_node.right = e_node

c_node.left = f_node
c_node.right = g_node

g_node.right = i_node
e_node.left = h_node

def preorder_traverse(subtree):
  if subtree is not None:
    print(subtree.data)
    preorder_traverse(subtree.left)
    preorder_traverse(subtree.right)
    
def inorder_traverse(subtree):
  if subtree is not None:
    inorder_traverse(subtree.left)
    print(subtree.data)
    inorder_traverse(subtree.right)
    
def post_order_traverse(subtree):
  if subtree is not None:
    post_order_traverse( subtree.left )
    post_order_traverse( subtree.right )
    print(subtree.data)
    
#post_order_traverse(a_node)
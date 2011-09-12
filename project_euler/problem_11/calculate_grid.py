"""
Calculate all possible values in a grid 4x4
"""

grid = list()
grid.append([26,38,40,67])
grid.append([95,63,94,39])
grid.append([97,17,78,78])
grid.append([20,45,35,14])

# sums can be left,right,up,down,diagonal
def generate_sums(grid):
  start = 0
  
  # right,left
  #[0][0],[0][1],[0][2],[0][3]
  #[1][0],[1][1],[1][2],[1][3]
  #[2][0],[2][1],[2][2],[2][3]
  #[3][0],[3][1],[3][2],[3][3]
  
  #up,down
  #[0][0],[1][0],[2][0],[3][0]
  #[0][1],[1][1],[2][1],[3][1]
  #[0][2],[1][2],[2][2],[3][2]
  #[0][3],[1][3],[2][3],[3][3]
  
  #diagonal
  #[0][0],[1][1],[2][2],[3][3]
  #[0][3],[1][2],[2][1],[3][0]
  
  right_left = []
  up_down = []
  diagonal = []
  
  d1 = []
  d2 = []
  count = len(grid[0])-1
  for i in range(0,len(grid[0])):
    # right,left
    right_left.append([ grid[i][0], grid[i][1], grid[i][2], grid[i][3] ])
    #up,down
    up_down.append([ grid[0][i], grid[1][i], grid[2][i], grid[3][i] ])
    d1.append(grid[i][i])
    d2.append(grid[i][count])
    count -= 1
  diagonal.append(d1)
  diagonal.append(d2)
  return {"right_left":right_left,"up_down":up_down,"diagonal":diagonal}

# pass full results dictionary through to sum_of_rows
def gather_sums(dict):
  
  maxi = {}
  current = []
  
  for key in dict:
    #print(key)
    tmp = sum_of_row(dict[key])
    #print(tmp)
    if len(maxi) == 0:
      maxi['maximus'] = tmp['maximus']
      maxi['row'] = tmp['row']
    elif tmp['maximus'] > maxi['maximus']:
      print("new maximum product = "+str(tmp['maximus']))
      maxi['maximus'] = tmp['maximus']
      maxi['row'] = tmp['row']
      #current[0] = dict[key][tmp[0]]
  return maxi

# pass a chunk from the list of lists in here to build sum
def sum_of_row(list):
  largest = {}
  for item in list:
    #print(count)
    c_sum = 1
    for elem in item:
      c_sum *= elem
    #print(sum(item))
    
    if len(largest) == 0:
      largest['maximus'] = c_sum
      largest['row'] = item
    elif largest['maximus'] < sum(item):
      print("new largest")
      largest['maximus'] = c_sum
      largest['row'] = item
  return (largest)
  
results = generate_sums(grid)
current = gather_sums(results)
print(current)
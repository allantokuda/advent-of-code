grid = File.read(ARGV[0]).split("\n").map { |line| line.chars.map(&:to_i) }





class Node
  attr_accessor :row_num, :col_num, :path, :node_risk, :total_risk

  def initialize(row_num, col_num, node_risk)
    @node_risk = node_risk
    @row_num = row_num
    @col_num = col_num
  end

  def adjacent_nodes(grid)
    [
      (grid[row_num+1][col_num] if row_num < grid.count - 1), # down
      (grid[row_num][col_num+1] if col_num < grid.first.count - 1), # right
      (grid[row_num-1][col_num] if row_num > 0), # up
      (grid[row_num][col_num-1] if col_num > 0), # left
    ].compact.reject(&:total_risk)
  end

  def set_source(source_node)
    # puts "set_source"
    # puts self
    # puts source_node.path.inspect
    # puts source_node.total_risk.inspect
    # puts
    @path = source_node.path + [self]
    @total_risk = source_node.total_risk + node_risk
  end

  def coords
    [row_num,col_num]
  end

  def coords_str
    coords.join(',')
  end
end

node_grid = grid.each_with_index.map { |row, i| row.each_with_index.map { |risk, j| Node.new(i, j, risk) } }
start_node = node_grid[0][0]
end_node = node_grid[-1][-1]
start_node.path = []
start_node.total_risk = 0
open_nodes = [start_node]
closed_nodes = []
while(end_node.total_risk.nil?)
  n = open_nodes.sort_by(&:total_risk).first # nearest open node
  adj = n.adjacent_nodes(node_grid)
  adj.map { |a| a.set_source(n) }
  closed_nodes += [n]
  open_nodes -= [n]
  open_nodes += adj
  #puts "#{closed_nodes.count}/#{10000}: #{open_nodes.map(&:coords_str).join('  ')}" # DEBUG
end

def paint_path(grid, path, color_code=31)
  path.each do |x,y|
    grid[x][y] = "\e[#{color_code}m#{grid[x][y]}\e[0m"
  end
end

g = grid.map(&:dup)
path = end_node.path.map(&:coords)
paint_path(g, path)
puts g.map { |row| row.join }

puts "Total risk: #{end_node.total_risk}"
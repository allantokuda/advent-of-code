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

def node_grid_from_values(value_grid)
  value_grid.each_with_index.map { |row, i| row.each_with_index.map { |risk, j| Node.new(i, j, risk) } }
end

def dijkstra_search(value_grid)
  node_grid = node_grid_from_values(value_grid)
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
  end
  end_node
end

def paint_path(grid, path, color_code=31)
  g = grid.map(&:dup)
  path.each do |x,y|
    g[x][y] = "\e[#{color_code}m#{g[x][y]}\e[0m"
  end
  puts g.map { |row| row.join }
end

end_node1 = dijkstra_search(grid)
paint_path(grid, end_node1.path.map(&:coords))
puts "Part 1: total risk: #{end_node1.total_risk}"

# Part 2: 25x larger map!
grid2 = begin
  (0..4).map do |i|
    grid.map(&:dup).map do |row|
      (0..4).map do |j|
        row.map do |cell|
          (cell + i + j - 1) % 9 + 1
        end
      end.flatten(1)
    end
  end.flatten(1)
end

end_node2 = dijkstra_search(grid2)
paint_path(grid2, end_node2.path.map(&:coords))
puts "Part 2: total risk: #{end_node2.total_risk}"
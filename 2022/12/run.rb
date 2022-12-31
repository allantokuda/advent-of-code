require 'set'
char_grid = ARGF.read.split("\n").map { |line| line.chars }

# This puzzle is a path finding exercise along an elevation map. Only horizontal and vertical movements are allowed.
# There are obstructions created by the rule that we cannot traverse to a neighbor cell whose elevation is more than 1 unit above the current cell.
# Part 1 calls for the use of A* algorithm to navigate a spiraling path to a known target. Dijkstra's algorithm is very slow for this and A* is very fast.

class Node
  attr_reader :row_num, :col_num, :character, :elevation, :marker
  attr_accessor :gone_so_far_distance, :heuristic_remaining_distance, :source_node, :on_path

  def initialize(row_num, col_num, character)
    @row_num = row_num
    @col_num = col_num
    @character = character
    @elevation = case character when 'S' then 1 when 'E' then 26 else (character.ord - 96) end
    @marker = case character when 'S' then :start_point when 'E' then :end_point end
    @gone_so_far_distance = 1e12 # infinity
  end

  def adjacent_nodes(node_grid, step_rule)
    [
      (node_grid[row_num+1][col_num  ] if row_num < node_grid.count - 1), # down
      (node_grid[row_num  ][col_num+1] if col_num < node_grid.first.count - 1), # right
      (node_grid[row_num-1][col_num  ] if row_num > 0), # up
      (node_grid[row_num  ][col_num-1] if col_num > 0), # left
    ].compact.select { |neighbor| step_rule.call(self, neighbor) }
  end

  def set_source(source_node)
    @source_node = source_node
  end

  def f_score
    gone_so_far_distance + heuristic_remaining_distance
  end

  def coords
    [row_num,col_num]
  end

  def coords_str
    coords.join(',')
  end

  def start_point?
    marker == :start_point
  end

  def end_point?
    marker == :end_point
  end

  def color_char
    on_path ? colorize(character) : character
  end
end

def node_grid_from_values(elevation_grid)
  elevation_grid.each_with_index.map do |elevation_row, i|
    elevation_row.each_with_index.map do |elevation, j|
      Node.new(i, j, elevation)
    end
  end
end

# Because diagonal movements are not allowed, Manhattan distance makes sense as a heuristic.
def manhattan_distance(node1, node2)
  (node1.row_num - node2.row_num).abs +
  (node2.col_num - node2.col_num).abs
end

# (f) is the f score which is the sum of g and h:
# (g) for Gone-So-Far (up to this node) distance
# (h) for Heruristic Remaining distance to target
def a_star_search(node_grid, start_node, end_node, step_rule)
  start_node.gone_so_far_distance = 0
  start_node.heuristic_remaining_distance = manhattan_distance(start_node, end_node)
  open_nodes = Set.new([start_node])
  closed_nodes = Set.new
  while(open_nodes.any?)
    n = open_nodes.min_by(&:f_score) # preferentially look at the most promising node first
    open_nodes.delete(n)
    closed_nodes.add(n)
    n.adjacent_nodes(node_grid, step_rule).each do |adjacent_node|
      # In this simple puzzle we just add a distance of 1 for each step,
      # but in general there may be edge weights to travel between nodes
      gone_so_far_distance = n.gone_so_far_distance + 1
      if gone_so_far_distance < adjacent_node.gone_so_far_distance
        adjacent_node.set_source(n)
        adjacent_node.gone_so_far_distance = gone_so_far_distance
        adjacent_node.heuristic_remaining_distance = manhattan_distance(adjacent_node, end_node)
        open_nodes.add(adjacent_node)
      end
    end
  end

  reconstruct_path(end_node).each do |n|
    n.on_path = true
  end
end

def dijkstra_search(node_grid, start_node, end_nodes, step_rule)
  start_node.gone_so_far_distance = 0
  open_nodes = Set.new([start_node])
  closed_nodes = Set.new
  while open_nodes.any?
    n = open_nodes.sort_by(&:gone_so_far_distance).first # preferentially look at the nearest open node to the start point
    return n if end_nodes.include?(n)
    open_nodes.delete(n)
    closed_nodes.add(n)
    n.adjacent_nodes(node_grid, step_rule).each do |adjacent_node|
      next if closed_nodes.include?(adjacent_node)
      adjacent_node.gone_so_far_distance = n.gone_so_far_distance + 1
      adjacent_node.set_source(n)
      open_nodes.add(adjacent_node)
    end
  end
end


def reconstruct_path(end_node)
  return [end_node] if end_node.source_node.nil?
  reconstruct_path(end_node.source_node) + [end_node]
end

def colorize(str)
  "\e[31m#{str}\e[0m"
end

def paint_path(node_grid)
  node_grid.each do |row|
    puts row.map(&:color_char).join('')
  end
  puts
end


# Part 1: find shortest uphill path from S to E
node_grid = node_grid_from_values(char_grid)
start_node = node_grid.flatten.detect(&:start_point?)
end_node = node_grid.flatten.detect(&:end_point?)
step_rule = ->(a, b) { b.elevation - a.elevation <= 1 }
a_star_search(node_grid, start_node, end_node, step_rule)
reconstruct_path(end_node).map { |node| node.on_path = true }
puts paint_path(node_grid)
puts "Part 1: total distance S to E: #{end_node.gone_so_far_distance}"
puts

# Part 2: find shortest downhill path from E back down to any 'a' elevation
node_grid = node_grid_from_values(char_grid)
start_node = node_grid.flatten.detect(&:end_point?)
end_nodes = Set.new(node_grid.flatten.select { |node| node.character == 'a' })
step_rule = ->(a, b) { a.elevation - b.elevation <= 1 }
end_node = dijkstra_search(node_grid, start_node, end_nodes, step_rule)
reconstruct_path(end_node).map { |node| node.on_path = true }
puts paint_path(node_grid)
puts "Part 2: distance from E back to 'a': #{end_node.gone_so_far_distance}"
puts

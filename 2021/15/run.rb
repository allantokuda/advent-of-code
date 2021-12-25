grid = File.read(ARGV[0]).split("\n")
map = grid.map { |line| line.chars.map(&:to_i) }

# Assuming for now that I never have to go up or left
def best_path(map, x1, y1, x2, y2, risk = 0, path = [])
  new_path = path + [[x1, y1]]
  new_risk = path.empty? ? risk : risk + map[x1][y1]
  return [new_risk, new_path] if x1 == x2 && y1 == y2
  [
    (best_path(map, x1 + 1, y1, x2, y2, new_risk, new_path) if x2 > x1),
    (best_path(map, x1, y1 + 1, x2, y2, new_risk, new_path) if y2 > y1),
  ].compact.min_by(&:first)
end

xmax = map.length
ymax = map.first.length

risk, path = best_path(map, 0,0,xmax-1,ymax-1)

# Display shortest path and its risk sum
grid = []
(xmax+1).times { grid << ' '*(ymax+1) }
path.each { |x,y| grid[x][y] = map[x][y].to_s }
puts grid

puts risk

# Reimplement as a "multiple best" finder, also allowing multiple endpoints: scored based on Manhattan progress

def best_paths(map, x1, y1, x2, y2, target_manhattan, risk = 0, path = [], limit = 10)
  new_path = path + [[x1, y1]]
  new_risk = path.empty? ? risk : risk + map[x1][y1]
  manhattan_progress = x1 + y1
  return [{ risk: new_risk, manhattan: manhattan_progress, path: new_path }] if manhattan_progress == target_manhattan
  results = []
  results += best_paths(map, x1 + 1, y1, x2, y2, target_manhattan, new_risk, new_path) if x2 > x1
  results += best_paths(map, x1, y1 + 1, x2, y2, target_manhattan, new_risk, new_path) if y2 > y1
  results.sort_by { |r| r[:risk] }.group_by { |p| p[:path].last }.map { |k, v| v.first }.first(limit)
end

paths = best_paths(map, 0,0,xmax-1,ymax-1, 15)

until paths.detect { |p| p[:manhattan] >= 198 }
  puts paths.map { |p| p[:manhattan] }.max
  paths = paths.map do |path|
    best_paths(map, *path[:path][-1], xmax-1, ymax-1, [path[:manhattan] + 5, 198].min, path[:risk], path[:path])
  end.flatten.sort_by { |r| r[:risk] }.group_by { |p| p[:path].last }.map { |k, v| v.first }.first(10)
end

paths.each do |p|
  puts p[:risk]
  puts
  xmax, ymax = p[:path].last
  grid = []
  (xmax+1).times { grid << ' '*(ymax+1) }
  p[:path].reverse.each { |x,y| grid[x][y] = map[x][y].to_s }
  puts grid
end

def display_path(path, grid)
  color_grid = grid.dup
  path.reverse.first(5).each { |x,y| color_grid[x] = color_grid[x][0...y] + "\e[31m" + color_grid[x][y] + "\e[0m" + color_grid[x][y+1..-1] }
  puts color_grid
end
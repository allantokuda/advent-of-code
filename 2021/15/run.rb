grid = File.read(ARGV[0]).split("\n").map { |line| line.chars.map(&:to_i) }

xmax = grid.length - 1
ymax = grid.first.length - 1

# "Multiple best" finder, also allowing multiple endpoints: scored based on Manhattan progress
def best_paths(grid, x1, y1, x2, y2, target_manhattan, risk = 0, path = [], start_point: true)
  new_path = path
  new_risk = risk
  unless start_point
    new_path += [[x1, y1]]
    new_risk += grid[x1][y1]
  end
  manhattan_progress = x1 + y1
  return [{ risk: new_risk, manhattan: manhattan_progress, path: new_path }] if manhattan_progress == target_manhattan
  results = []
  results += best_paths(grid, x1 + 1, y1, x2, y2, target_manhattan, new_risk, new_path, start_point: false) if x2 > x1
  results += best_paths(grid, x1, y1 + 1, x2, y2, target_manhattan, new_risk, new_path, start_point: false) if y2 > y1
  results.sort_by { |r| r[:risk] }.group_by { |p| p[:path].last }.map { |k, v| v.first }.first(20)
end

results = best_paths(grid, 0,0,xmax,ymax, 16)

until results.detect { |r| r[:manhattan] >= xmax + ymax  }
  results = results.map do |path|
    best_paths(grid, *path[:path][-1], xmax, ymax, [path[:manhattan] + 4, xmax + ymax].min, path[:risk], path[:path])
  end.flatten.sort_by { |r| r[:risk] }.group_by { |r| r[:path].last }.map { |k, v| v.first }.first(100)
end

def paint_path(grid, result, color_code=31)
  result[:path].reverse.each do |x,y|
    grid[x][y] = "\e[#{color_code}m#{grid[x][y]}\e[0m"
  end
end

g = grid.map(&:dup)
results.each_with_index do |r, i|
  paint_path(g, r, 31 + i % 6)
end
puts g.map { |row| row.join }

puts
puts "Risk: #{results.first[:risk]}"
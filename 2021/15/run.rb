grid = File.read(ARGV[0]).split("\n").map { |line| line.chars.map(&:to_i) }

xmax = grid.length - 1
ymax = grid.first.length - 1

# "Multiple best" finder, also allowing multiple endpoints: scored based on Manhattan progress

def best_paths(grid, x1, y1, x2, y2, target_manhattan, limit=100, x=x1, y=y1, risk = 0, path = [], start_point = true, backtracks = 0)
  return [] if backtracks > 2 || !(x1..x2).include?(x) || !(y1..y2).include?(y) || (!start_point && path.include?([x, y]))
  new_path = path
  new_risk = risk
  unless start_point
    new_path += [[x, y]]
    new_risk += grid[x][y]
    #puts backtracks.to_s + ' -> ' + path.inspect
  end
  manhattan_progress = x + y
  return [{ risk: new_risk, manhattan: manhattan_progress, path: new_path }] if manhattan_progress == target_manhattan
  results = []
  results += best_paths(grid, x1, y1, x2, y2, target_manhattan, limit, x+1, y, new_risk, new_path, false, backtracks)
  results += best_paths(grid, x1, y1, x2, y2, target_manhattan, limit, x, y+1, new_risk, new_path, false, backtracks)
  results += best_paths(grid, x1, y1, x2, y2, target_manhattan, limit, x-1, y, new_risk, new_path, false, backtracks + 1)
  results += best_paths(grid, x1, y1, x2, y2, target_manhattan, limit, x, y-1, new_risk, new_path, false, backtracks + 1)
  results.sort_by { |r| r[:risk] }.group_by { |p| p[:path].last }.map { |k, v| v.first }.first(limit)
end

results = best_paths(grid, 0,0,xmax,ymax, 13)

until results.detect { |r| r[:manhattan] >= xmax + ymax  }
  results = results.map do |result|
    best_paths(grid, 0, 0, xmax, ymax, [result[:manhattan] + 3, xmax + ymax].min, 100, *result[:path][-1], result[:risk], result[:path])
  end.flatten.sort_by { |r| r[:risk] }.group_by { |r| r[:path].last }.map { |k, v| v.first }.first(200)
  puts results.first.slice(:manhattan, :risk)
end

def paint_path(grid, path, color_code=31)
  path.each do |x,y|
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

results = (0..xmax).map { |x| y = xmax - x; best_paths(grid, 0, 0, xmax, ymax, x+y+3, x, y) }.flatten.sort_by { |r| r[:risk] }.group_by { |r| r[:path].last }.map { |k, v| v.first }.first(10)

results = []
(0..19).each do |diagonal|
  manhattan = diagonal * 10
  puts [manhattan, results.count].inspect
  x_range, y_func = begin
    if manhattan <= xmax
      [(0..manhattan), ->(x) { ymax - x - manhattan }]
    else
      [((manhattan - xmax)..xmax), ->(x) { ymax - x }]
    end
  end
  results += x_range.map { |x| y = y_func.call(x); best_paths(grid, 0, 0, xmax, ymax, x+y+10, x, y) }.flatten.sort_by { |r| r[:risk] }.group_by { |r| r[:path].last }.map { |k, v| v.first }.first(10)
end
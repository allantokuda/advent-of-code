map = File.read(ARGV[0]).split("\n").map { |line| line.chars.map(&:to_i) }

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

# Display shortest path
grid = []
(xmax+1).times { grid << ' '*(ymax+1) }
path.each { |x,y| grid[x][y] = map[x][y].to_s }
puts grid

puts risk
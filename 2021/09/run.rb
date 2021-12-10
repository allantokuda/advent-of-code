heights = File.read(ARGV[0]).split("\n").map { |line| line.chars.map(&:to_i) }
length, width = [heights.length, heights.first.length]

def neighbors(i, j, heights, width, length)
  [
    (heights[i][j-1] if j > 0),
    (heights[i][j+1] if j < width - 1),
    (heights[i-1][j] if i > 0),
    (heights[i+1][j] if i < length - 1),
  ].compact
end

def risk(i, j, heights, width, length)
  current = heights[i][j]
  return 0 unless neighbors(i, j, heights, width, length).all? { |n| n > current }
  current + 1
end

risk_sum = (0...length).map do |i|
  (0...width).map do |j|
    risk(i, j, heights, width, length)
  end
end.flatten.sum

# Part 1
puts risk_sum
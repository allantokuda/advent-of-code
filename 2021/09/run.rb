require 'ostruct'
chart = File.read(ARGV[0]).split("\n").map { |line| line.chars.map { |c| OpenStruct.new(z: c.to_i) } }
length, width = [chart.length, chart.first.length]

def neighbors(i, j, chart, width, length)
  [
    (chart[i][j-1] if j > 0),
    (chart[i][j+1] if j < width - 1),
    (chart[i-1][j] if i > 0),
    (chart[i+1][j] if i < length - 1),
  ].compact
end


# Part 1

def risk(i, j, chart, width, length)
  current = chart[i][j]
  return 0 unless neighbors(i, j, chart, width, length).all? { |n| n.z > current.z }
  current.z + 1
end

risk_sum = (0...length).map do |i|
  (0...width).map do |j|
    risk(i, j, chart, width, length)
  end
end.flatten.sum

puts risk_sum


# Part 2

# Initialize cells with unique numbers
bnum = 0
(0...length).each do |i|
  (0...width).each do |j|
    current = chart[i][j]
    next if current.z == 9
    current.basin = (bnum += 1)
  end
end

# Create neighbor groups that share lowest number within group; repeat.
# Technically could be a large number of iterations;
# I cheated here a bit because it was fast enough to manually trial and error until the result converged.
3.times do
  (0...length).each do |i|
    (0...width).each do |j|
      current = chart[i][j]
      next if current.z == 9
      set = ([current] + neighbors(i, j, chart, width, length).reject { |n| n.z == 9 })
      group_min = set.map(&:basin).min
      set.each { |item| item.basin = group_min }
    end
  end
end

# Pretty print the basin map
puts
puts chart.map { |row| row.map(&:basin).map { |b| b ? (b%32).to_s(32) : ' ' }.join }
puts

puts chart.flatten.select { |c| c.basin }.inject({}) { |h, e| h[e.basin] ||= 0; h[e.basin] += 1; h }.values.sort.last(3).inject(&:*)

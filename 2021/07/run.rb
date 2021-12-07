vals = File.read(ARGV[0]).split(',').map(&:to_i).sort

# Way overcomplicated solution to part 1 (that I thought would be needed for performance)
p = vals.inject({}) { |h, v| h[v] ||= 0; h[v] += 1; h }.to_a.map { |r| { x: r[0], count: r[1] } }
n = p.count

total = 0; p        .each { |p| p[:left_count]  = total; total += p[:count] }
total = 0; p.reverse.each { |p| p[:right_count] = total; total += p[:count] }

(0...n-1).each { |i| p[i][:right_dist] = p[i+1][:x] - p[i  ][:x] }
(1...n  ).each { |i| p[i][:left_dist]  = p[i  ][:x] - p[i-1][:x] }

(0...n-1).each { |i| p[i][:right_cost] = p[i][:right_dist] * p[i][:right_count] }
(1...n  ).each { |i| p[i][:left_cost]  = p[i][:left_dist]  * p[i][:left_count] }

while p.count > 1 do
  if p.last[:left_cost] > p.first[:right_cost]
    p.pop[:left_cost]
  else
    p.shift[:right_cost]
  end
end

endpos = p.first[:x]

puts vals.map { |val| (val - endpos).abs }.sum


# Part 2: binary search
def totalcost(testpos, vals)
  totalcost = vals.map do |val|
    dist = (testpos - val).abs
    cost = (1..dist).inject(&:+) || 0
  end.sum
end

min = vals.first
max = vals.last
while max > min
  tests = (0..4).map { |i| min + (max - min) * i / 4 }
  results = tests.map { |t| [t, totalcost(t, vals)] }
  best3 = results.sort_by(&:last)[0..2].sort
  min, max, value = best3.first.first, best3.last.first, best3.first.last
end
puts value
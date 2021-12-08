vals = File.read(ARGV[0]).split(',').map(&:to_i).sort

def totalcost(testpos, vals, dist_function)
  totalcost = vals.map do |val|
    dist = (testpos - val).abs
    cost = dist_function.call(dist)
  end.sum
end

def binary_search(vals, dist_function)
  min = vals.first
  max = vals.last
  while max > min
    tests = (0..2).map { |i| (min + (max - min) * i / 2.0).round }
    results = tests.map { |t| [t, totalcost(t, vals, dist_function)] }.uniq
    best = results.sort_by(&:last)[0..-2].sort # remove the worst score of the set (usually 3 until the end)
    min, max, value = best.first.first, best.last.first, best.first.last
  end
  value
end

puts binary_search(vals, ->(dist) { dist }) # part 1
puts binary_search(vals, ->(dist) { dist * (dist + 1) / 2 }) # part 2
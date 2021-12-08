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
    if max == min + 1
      result1, result2 = [min, max].map { |t| [t, totalcost(t, vals, dist_function)] }
      best = [result1, result2].sort_by(&:last).first
      max = min = best.first
      value = best.last
    else
      tests = (0..4).map { |i| min + (max - min) * i / 4 }
      results = tests.map { |t| [t, totalcost(t, vals, dist_function)] }
      best3 = results.sort_by(&:last)[0..2].sort
      min, max, value = best3.first.first, best3.last.first, best3.first.last
    end
  end
  value
end

puts binary_search(vals, ->(dist) { dist }) # part 1
puts binary_search(vals, ->(dist) { dist * (dist + 1) / 2 }) # part 2
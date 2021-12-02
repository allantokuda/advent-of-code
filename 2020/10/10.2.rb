nums = ARGF.readlines.map(&:to_i).sort
nums.unshift(0)
nums.push(nums.last + 3)

ways = { 0 => [] }
counts = { 0 => 1 }
(1...nums.length-1).each do |i|
  ways[i] = (i-3..i-1).select { |j| j >= 0 && (nums[j] >= (nums[i] - 3)) }#.map { |j| puts "#{nums[j]} >= #{nums[i]} - 3"; j }
  counts[i] = ways[i].sum{|w| counts[w]}
end
puts counts.to_a.last.last

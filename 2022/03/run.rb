sacks = File.readlines(ARGV[0]).map(&:strip).map(&:chars)

priority = Hash[(['_'] + ('a'..'z').to_a + ('A'..'Z').to_a).each_with_index.to_a]

# Part 1
puts sacks.sum { |s| priority[s.each_slice(s.count/2).to_a.inject(&:&).first] }

# Part 2
puts sacks.each_slice(3).to_a.sum { |group| priority[group.inject(&:&).first] }


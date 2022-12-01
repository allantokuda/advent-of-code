grouped_sums = File.read(ARGV[0]).split("\n\n").map { |group| group.split("\n").map(&:to_i).sum }

# part 1
puts grouped_sums.max

# part 2
puts grouped_sums.sort[-3..-1].sum

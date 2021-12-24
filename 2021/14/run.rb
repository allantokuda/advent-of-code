lines = File.read(ARGV[0]).split("\n")
chain = lines.first.dup
insertions = lines[2..-1].map { |cmd| cmd.split(' -> ') }

# Part 1: use string substitution.
# Use lowercase at each step to keep track of the "new" items
# so that all substitutions are "simultaneous".
10.times do |i|
  insertions.each do |pair, insert|
    chain.gsub!(pair, pair[0] + insert.downcase + pair[1])
  end
  chain.upcase!
end

freq = chain.chars.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.to_a.sort_by(&:last)
puts "Part 1 answer code: #{freq[-1][1] - freq[0][1]}"

# Part 2: problem too big to solve by brute force!
# This time, just keep track of pair counts.
chain = lines.first.dup # reset
pairs = (0...chain.length-1).map { |i| chain[i] + chain[i+1] }
pair_counts = Hash[pairs.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.to_a.sort_by(&:last)]

40.times do |i|
  changes = Hash.new(0)
  insertions.each do |pair, insert|
    n = pair_counts[pair]
    next unless n && n > 0
    changes[pair[0] + insert] += n
    changes[insert + pair[1]] += n
    changes[pair] -= n
  end
  changes.each do |pair, increase|
    pair_counts[pair] ||= 0
    pair_counts[pair] += increase
  end
  pair_counts = Hash[pair_counts.to_a.sort_by(&:last)]
end

# To get character counts, aggregate first-of-each-pair counts
freq = pair_counts.to_a.inject(Hash.new(0)) { |h,e| h[e[0][0]] += e[1]; h }
freq[chain[-1]] += 1 # last character is never first of a pair, but also never changes :)
freq = freq.to_a.sort_by(&:last)
puts "Part 2 answer code: #{freq[-1][1] - freq[0][1]}"

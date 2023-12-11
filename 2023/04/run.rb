lines = ARGF.read.split("\n")

overlaps = lines.map do |line|
  parts = line.split(/[:|]/)
  card_num = parts[0].split(/\s+/).last.to_i
  winning  = parts[1].strip.split(/\s+/).map(&:to_i)
  actual   = parts[2].strip.split(/\s+/).map(&:to_i)
  (winning & actual).size
end

# Part 1: sum exponential scores calculated from overlap counts
puts overlaps.sum { |n| (2**(n-1)).to_i }

# Part 2: count how many cards are won due to overlap counts in previous cards
n = overlaps.size
counts = [1]*n
(n-1).times do |i|
  overlaps[i].times do |j|
    break if i+1+j >= counts.size
    counts[i+1+j] += counts[i]
  end
end
puts counts.sum
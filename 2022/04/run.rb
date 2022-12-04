pairs = File.read(ARGV[0]).split("\n").map do |pair|
  pair.split(',').map do |partner|
    Range.new(*partner.split('-').map(&:to_i)).to_a
  end.sort_by(&:count)
end

# Part 1
puts pairs.count { |pair| pair.inject(:-).none? }

# Part 2
puts pairs.count { |pair| pair.inject(:&).any? }

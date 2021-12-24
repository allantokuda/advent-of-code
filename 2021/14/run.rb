lines = File.read(ARGV[0]).split("\n")
chain = lines.first
insertions = lines[2..-1].map { |cmd| cmd.split(' -> ') }

10.times do |i|
  insertions.each do |pair, insert|
    chain.gsub!(pair, pair[0] + insert.downcase + pair[1])
  end
  chain.upcase!
end

freq = chain.chars.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.to_a.sort_by(&:last)

puts "Part 1 answer code: #{freq[-1][1] - freq[0][1]}"

adapters = ARGF.readlines.map(&:to_i).sort
adapters.unshift(0)
adapters.push(adapters.last + 3)

count = Hash.new(0)
(1...adapters.length).each do |i|
  count[adapters[i] - adapters[i-1]] += 1
end
puts count[1]*count[3]

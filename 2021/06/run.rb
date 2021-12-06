ages = File.read(ARGV[0]).split("\n").first.split(",").map(&:to_i)
h = ages.inject(Hash.new(0)) { |h, age| h[age] ||= 0; h[age] += 1; h }

def step(h)
  (0..8).each do |age|
    h[age - 1] = h[age]
  end
  h[6] ||= 0
  h[6] += h[-1]
  h[8] = h[-1]
  h[-1] = 0
end

# Part 1
80.times { step(h) }
puts h.values.sum

# Part 2
(256-80).times { step(h) }
puts h.values.sum

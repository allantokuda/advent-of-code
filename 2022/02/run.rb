lines = File.read(ARGV[0]).split("\n").map { |line| line.split(" ") }.map { |a,b| [a.ord-64, b.ord-87] }

# part 1
puts lines.map { |a,b| ((b-a)%3+1)%3*3 + b }.sum

# part 2
puts lines.map { |a,b| (b-1)*3 + (a+b)%3+1 }.sum

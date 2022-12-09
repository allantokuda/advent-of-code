require "matrix"

movements = ARGF.read.split("\n").map(&:split)

head = Vector[0,0]
tail = Vector[0,0]

tail_trail = []

VECTOR = {
  'R' => Vector[ 1, 0],
  'L' => Vector[-1, 0],
  'U' => Vector[ 0, 1],
  'D' => Vector[ 0,-1]
}

movements.each do |direction, distance|
  vector = VECTOR[direction]
  distance.to_i.times do
    head += vector
    dist = head - tail
    if (components = dist.to_a).map(&:abs).max > 1
      tail += Vector[*components.map { |n| n == 0 ? 0 : n / n.abs }]
    end
    tail_trail << tail
  end
end

# Part 1
puts tail_trail.uniq.count

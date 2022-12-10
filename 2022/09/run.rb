require "matrix"

# Usage:
#   ruby run.rb test 2   # part 1
#   ruby run.rb test 10  # part 2

movements = File.read(ARGV[0]).split("\n").map(&:split)
length = ARGV[1].to_i

rope = Array.new(length) { { :v => Vector[0,0] } }
tail_trail = []

VECTOR = {
  'R' => Vector[ 1, 0],
  'L' => Vector[-1, 0],
  'U' => Vector[ 0, 1],
  'D' => Vector[ 0,-1]
}

trail = movements.map do |direction, distance|
  vector = VECTOR[direction]
  distance.to_i.times do
    rope.first[:v] += vector
    rope.each_cons(2) do |lead, follow|
      dist = lead[:v] - follow[:v]
      if (components = dist.to_a).map(&:abs).max > 1
        follow[:v] += Vector[*components.map { |n| n == 0 ? 0 : n / n.abs }]
      end
    end
    tail_trail << rope.last[:v]
  end
end.uniq

puts tail_trail.uniq.count

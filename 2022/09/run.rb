require "matrix"

# Usage:
#   ruby run.rb test 2   # part 1
#   ruby run.rb test 10  # part 2

movements = File.read(ARGV[0]).split("\n").map(&:split)
rope_length = ARGV[1].to_i

DIRECTION_MAP = {
  'R' => Vector[ 1, 0],
  'L' => Vector[-1, 0],
  'U' => Vector[ 0, 1],
  'D' => Vector[ 0,-1]
}

rope = Array.new(rope_length) { { :pos => Vector[0,0] } }
tail_trail = []

movements.map do |direction_code, step_count|
  vector = DIRECTION_MAP[direction_code]
  step_count.to_i.times do
    rope.first[:pos] += vector
    rope.each_cons(2) do |lead_knot, follow_knot|
      # Move 'follow' rope knot to catch up with its 'lead' knot if lead is more than one space away
      dist = lead_knot[:pos] - follow_knot[:pos]
      if dist.to_a.map(&:abs).max > 1
        follow_knot[:pos] += Vector[
          # For movement vector, start with distance vector and reduce each coordinate to absolute value of 0 or 1.
          # So [2, -1] distance gives [1,-1] movement vector. This causes preferencially diagonal movement.
          *dist.to_a.map { |n| n == 0 ? 0 : n / n.abs }
        ]
      end
    end
    tail_trail << rope.last[:pos]
  end
end

puts tail_trail.uniq.count

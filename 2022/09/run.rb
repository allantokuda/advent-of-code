require "matrix"

# Usage:
#   ruby run.rb test 2   # part 1
#   ruby run.rb test 10  # part 2
#   ruby run.rb test 10 animate  # add animation

movements = File.read(ARGV[0]).split("\n").map(&:split)
rope_length = (ARGV[1] || 2).to_i # default to length 2 for part 1 result

DIRECTION_MAP = {
  'R' => Vector[ 1, 0],
  'L' => Vector[-1, 0],
  'U' => Vector[ 0, 1],
  'D' => Vector[ 0,-1]
}

rope = Array.new(rope_length) { { :pos => Vector[0,0] } }
tail_trail = []

def animate_rope(rope, width, height)
  xvals, yvals = rope.map { |knot| knot[:pos].to_a }.transpose
  grid = (0...height).map do |y|
    ' .'*width
  end
  rope.reverse.each_with_index { |knot, i| x,y = knot[:pos].to_a; begin; grid[y-height/2][x*2-width+1] = (rope.count - i - 1).to_s; rescue; break; end }
  puts grid
  8.times { puts }
  sleep 0.05
end

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
    animate_rope(rope, 40, 30) if ARGV[2] == 'animate'
  end
end

puts tail_trail.uniq.count

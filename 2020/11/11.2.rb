prev = ARGF.readlines

def vector_check(grid, x, y, dx, dy)
  size = grid[0].length
  occupied = false
  scale = 1
  loop do
    ix = x + (dx * scale)
    iy = y + (dy * scale)
    break unless [ix, iy].all? { |n| (0...size).cover?(n) }
    char = grid[ix]&.[](iy)
    is_seat = (char =~ /[#L]/)
    if is_seat
      occupied = char == '#'
      break
    end
    scale += 1
  end
  occupied
end


vectors = [-1,0,1].yield_self {|v| v.product(v)} - [[0,0]]
occupied = nil
loop do
  changes = 0

  updated = prev.each_with_index.map do |row, x|
    row.split('').each_with_index.map do |cell, y|
      next '.' if cell == '.'

      seen = vectors.count { |dx,dy| vector_check(prev, x, y, dx, dy) }

      if cell == '#' && seen >= 5
        changes += 1
        'L'
      elsif cell == 'L' && seen == 0
        changes += 1
        '#'
      else
        cell
      end
    end.join
  end

  prev = updated.dup
  break if changes.zero?
end

# 2227
puts occupied

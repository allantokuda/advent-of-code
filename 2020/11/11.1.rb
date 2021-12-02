prev = ARGF.readlines

vectors = [-1,0,1].yield_self {|v| v.product(v)} - [[0,0]]
occupied = nil
loop do
  changes = 0

  updated = prev.each_with_index.map do |row, x|
    row.split('').each_with_index.map do |cell, y|
      next '.' if cell == '.'
      adj = vectors.count { |dx,dy| next if x + dx < 0 || y + dy < 0; prev[x + dx]&.[](y + dy) == '#' }
      if cell == '#' && adj >= 4
        changes += 1
        'L'
      elsif cell == 'L' && adj == 0
        changes += 1
        '#'
      else
        cell
      end
    end.join
  end

  puts updated.map { |line| line.gsub(/[.L]/, ' ') }
  occupied = updated.join.count('#')
  prev = updated.dup
  break if changes.zero?
end

puts occupied

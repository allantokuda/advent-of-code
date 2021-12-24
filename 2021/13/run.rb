lines = File.read(ARGV[0]).split("\n")

def fold_val(val, fold_pos)
  return val if val < fold_pos
  fold_pos - (val - fold_pos)
end

folds = lines.select { |line| line =~ (/fold/) }.map { |cmd| cmd.split.last.split('=').yield_self { |pair| [pair[0], pair[1].to_i] } }
coords = lines.select { |line| line =~ (/,/) }.map { |xy| xy.split(',').map(&:to_i) }

folds.each_with_index do |fold, i|
  axis, fold_pos = fold
  coords.map! do |x, y|
    if axis == 'x'
      [fold_val(x, fold_pos), y]
    else
      [x, fold_val(y, fold_pos)]
    end
  end.uniq!
  puts "#{coords.count} dots remaining after fold #{i}"
end

# Part 2: print the folded grid
xmax, ymax = coords.transpose.map(&:max)
grid = []
(ymax+1).times { grid << ' '*(xmax+1) }
coords.each { |x,y| grid[y][x] = '*' }
puts grid

tree_rows = ARGF.read.split("\n").map { |row| row.chars.map { |char| { h: char.to_i } } }

def all_directions(grid_rows, initial_value, &block)
  [grid_rows, grid_rows.transpose].each do |horiz_vert_rows|
    [horiz_vert_rows, horiz_vert_rows.map(&:reverse)].each do |any_direction_rows|
      any_direction_rows.each do |any_direction_row|
        accumulator = initial_value.dup
        any_direction_row.each do |item|
          accumulator = yield item, accumulator
        end
      end
    end
  end
end


# Part 1
all_directions(tree_rows, -1) do |tree, visible_height|
  if tree[:h] > visible_height
    tree[:v] = true
    visible_height = tree[:h]
  end
  visible_height
end
puts tree_rows.sum { |row| row.count { |tree| tree[:v] }}
tree_rows = ARGF.read.split("\n").map { |row| row.chars.map { |char| { height: char.to_i } } }

# Right, Left, Down, Up!
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
  if tree[:height] > visible_height
    tree[:visible] = true
    visible_height = tree[:height]
  end
  visible_height
end
puts tree_rows.sum { |row| row.count { |tree| tree[:visible] }}


# Part 2
all_directions(tree_rows, []) do |tree, heights_passed|
  visible_count = if heights_passed.none?
                    0
                  elsif blocked_index = heights_passed.index { |height| height >= tree[:height] }
                    blocked_index + 1
                  else
                    heights_passed.count
                  end
  (tree[:views] ||= []) << visible_count
  heights_passed.unshift(tree[:height])
end
puts tree_rows.map { |row| row.map { |tree| tree[:views].inject(:*) } }.flatten.max
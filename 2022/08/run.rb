tree_rows = ARGF.read.split("\n").map { |row| row.chars.map { |char| { h: char.to_i } } }

[tree_rows, tree_rows.transpose].each do |horiz_vert_rows|
  [horiz_vert_rows, horiz_vert_rows.map(&:reverse)].each do |any_direction_rows|
    any_direction_rows.each do |any_direction_row|
      visible_height = -1
      any_direction_row.each do |tree|
        if tree[:h] > visible_height
          visible_height = tree[:h]
          tree[:v] = true
        end
      end
    end
  end
end

# Part 1
puts tree_rows.sum { |row| row.count { |tree| tree[:v] }}
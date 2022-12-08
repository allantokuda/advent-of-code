tree_rows = ARGF.read.split("\n").map { |row| row.chars.map { |char| { h: char.to_i } } }

[
  tree_rows,
  tree_rows.transpose,
  tree_rows.map(&:reverse),
  tree_rows.transpose.map(&:reverse)
].each do |transformation|
  transformation.each do |row|
    visible_height = -1
    row.each do |tree|
      if tree[:h] > visible_height
        visible_height = tree[:h]
        tree[:v] = true
      end
    end
  end
end

puts tree_rows.inspect

# Part 1
puts tree_rows.sum { |row| row.count { |tree| tree[:v] }}
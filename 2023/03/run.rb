schematic = ARGF.read.split("\n").map { |line| line.split('') }
symbols = %w[* @ / & % + # = - $]

# duplicate array of arrays but all spaces, for painting copies of active numbers as they are found
duplicate = schematic.map { |row| row.map { |col| ' ' } }

def copy_to_duplicate_if_numeric_and_not_already_found(schematic, duplicate, row_index, col_index)
  item = schematic[row_index][col_index]
  if item && item.match(/\d/) && duplicate[row_index][col_index] == ' '
    duplicate[row_index][col_index] = item
    copy_to_duplicate_if_numeric_and_not_already_found(schematic, duplicate, row_index, col_index - 1)
    copy_to_duplicate_if_numeric_and_not_already_found(schematic, duplicate, row_index, col_index + 1)
  end
end

schematic.each_with_index do |row, row_index|
  row.each_with_index do |symbol, col_index|
    if symbols.include?(symbol)
      [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]].each do |offset|
        offset_row = row_index + offset[0]
        offset_col = col_index + offset[1]
        if offset_row >= 0 && offset_row < schematic.length && offset_col >= 0 && offset_col < row.length
          item = schematic[offset_row][offset_col]
          if item.match(/\d/)
            copy_to_duplicate_if_numeric_and_not_already_found(schematic, duplicate, offset_row, offset_col)
          end
        end
      end
    end
  end
end

# sum all numbers across all rows
puts duplicate.map { |row| row.join('') }.join("\n").scan(/\d+/).map(&:to_i).inject(:+)
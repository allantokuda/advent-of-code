filedata = ARGF.read
file_lines = filedata.split("\n")

def substring_positions(string, substring)
  positions = []
  offset = -1
  while offset = string.index(substring, offset+1)
    positions << offset
  end
  positions
end

# Index the locations of all numbers and symbols in the schematic
numbers_index = []
symbols_index = []
file_lines.each_with_index do |row, i|
  row.scan(/\d{1,3}/).each do |number|
    substring_positions(row, number).each do |j|
      numbers_index << [i, j, j+number.length-1, number.to_i]
      # numbers_index << { row: i, col_start: j, col_end: j+number.length-1, number: number.to_i }
    end
  end
  row.scan(/[-+*\/=%@#&$]/).each do |symbol|
    substring_positions(row, symbol).each do |j|
      symbols_index << [i, j, symbol]
      #symbols_index << { row: i, col: j, symbol: symbol }
    end
  end
end

def number_symbol_adjacent(number, symbol)
  (symbol[0] - number[0]).abs <= 1 &&
    symbol[1] >= number[1] - 1 &&
    symbol[1] <= number[2] + 1
end

# Part 1: find all numbers adjacent (including diagonally) to any symbol
puts begin
  numbers_index.select do |number|
    symbols_index.any? do |symbol|
      number_symbol_adjacent(number, symbol)
    end
  end.sum(&:last)
end

# Part 2: find all pairs of numbers adjacent to an asterisk where they are the only two numbers adjacent to the asterisk
puts begin
  stars = symbols_index.select { |symbol| symbol.last == '*' }
  stars.map do |symbol|
    adjacent_numbers = numbers_index.select do |number|
      number_symbol_adjacent(number, symbol)
    end
    next unless adjacent_numbers.length == 2
    adjacent_numbers.map(&:last).inject(:*)
  end.compact.sum
end
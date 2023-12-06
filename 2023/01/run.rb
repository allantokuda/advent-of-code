lines = ARGF.read.split("\n")

# Part 1
digit_lines = lines.map { |line| line.scan(/[0-9]/).map(&:to_i) }
numbers = digit_lines.map { |digit_line| digit_line.first * 10 + digit_line.last }
puts numbers.sum

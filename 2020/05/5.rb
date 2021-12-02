codes = File.readlines('input5')

def decode(str)
  str.gsub(/[FL]/, '0').gsub(/[BR]/, '1').to_i(2)
end

def seat_for(code)
  row = decode code[0..6]
  col = decode code[7..9]
  { code: code, row: row, col: col, id: row * 8 + col }
end

seats = codes.map { |code| seat_for(code) }.sort_by { |seat| seat[:id] }
puts seats

# Part 1
puts seats.last[:id]

# Part 2
ids = seats.map { |seat| seat[:id] }
prev = 10
puts ids.detect { |id| id != (prev += 1) } - 1
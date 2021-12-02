map = File.readlines('input3')

# Part 1
count = 0
map.each_with_index { |line, i| count += 1 if line[(i*3)%31] == '#' }
puts count

# Part 2
results = [[1,1],[3,1],[5,1],[7,1],[1,2]].map do |right, down|
  x = 0
  y = 0
  count = 0
  while x < map.length
    count += 1 if map[x][y] == '#'
    x += down
    y = (y + right) % 31
  end
  puts count
  count
end
puts results.reduce(1) { |product, n| product * n }
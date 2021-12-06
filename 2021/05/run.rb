filelines = File.read(ARGV[0]).split("\n")
ventlines = filelines.map { |l| l.split(' -> ').map { |coord_str| x, y = coord_str.split(',').map(&:to_i); { x: x, y: y } } }
axes = [:x, :y]

map = {}
ventlines.each do |v|
  vector = axes.map { |axis| v[1][axis] <=> v[0][axis] }
  steps = axes.map { |axis| (v[1][axis] - v[0][axis]).abs + 1 }.max

  # skip diagnoals for part 1 (send "2" as 2nd parameter to run part 2)
  next if ARGV[1] != '2' && vector.all? { |u| u != 0 }

  steps.times do |i|
    x = v[0][:x] + vector[0] * i
    y = v[0][:y] + vector[1] * i
    key = [x,y].join(',')
    map[key] ||= 0
    map[key] += 1
  end
end

puts map.values.select { |n| n > 1 }.count

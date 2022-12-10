commands = File.read(ARGV[0]).split("\n").map { |line| cmd, num = line.split; { name: cmd, value: num.to_i } }

DURATION = { 'addx' => 2, 'noop' => 1 }

cooldown = 0
i = 1
x = 1
x_history = []
while commands.any? || cooldown > 0
  puts i
  puts "start x = #{x}  cooldown: #{cooldown}"
  x_history << { i: i, x: x }
  if cooldown == 0
    command = commands.shift
    puts "  begin #{command}"
    cooldown = DURATION[command[:name]]
  end
  cooldown -= 1
  if cooldown == 0 && command[:name] == 'addx'
    x += command[:value]
    puts "  now add #{command[:value]}"
  end
  puts "end   x = #{x}"
  puts
  i += 1
end

puts x_history.map {|h| h.values.join(' ') }

keypoints = (0..5).map { |n| 20 + n*40 }
puts keypoints.map { |k| x_history[k-1].values.inject(:*) }.sum

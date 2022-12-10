commands = File.read(ARGV[0]).split("\n").map { |line| cmd, num = line.split; { name: cmd, value: num.to_i } }

DURATION = { 'addx' => 2, 'noop' => 1 }

cooldown = 0
i = 1
x = 1
history = []

while commands.any? || cooldown > 0
  history << { i: i, x: x }
  if cooldown == 0
    command = commands.shift
    cooldown = DURATION[command[:name]]
  elsif cooldown == 1 && command[:name] == 'addx'
    x += command[:value]
  end
  cooldown -= 1
  i += 1
end

keypoints = (0..5).map { |n| 20 + n*40 }
puts keypoints.map { |k| history[k-1].values.inject(:*) }.sum

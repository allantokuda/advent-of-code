commands = File.read(ARGV[0]).split("\n").map { |line| line.split(' ') }.map { |dir, amt| [dir, amt.to_i] }

# part 1
init = { x: 0, y: 0 }
final = commands.reduce(init) do |pos, command|
  dir,amt = command

  case dir
  when 'up' then pos[:y] -= amt
  when 'down' then pos[:y] += amt
  when 'forward' then pos[:x] += amt
  end

  pos
end
puts final[:x] * final[:y]
puts

# part 2
init = { x: 0, y: 0, aim: 0 }
final = commands.reduce(init) do |state, command|
  action,amt = command

  case action
  when 'up' then state[:aim] -= amt
  when 'down' then state[:aim] += amt
  when 'forward'
    state[:x] += amt
    state[:y] += amt * state[:aim]
  end

  state
end
puts final[:x] * final[:y]


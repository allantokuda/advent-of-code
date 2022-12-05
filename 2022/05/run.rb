picture, move_lines = File.read(ARGV[0]).split("\n\n")

moves = move_lines.split("\n").map do |line|
  Hash[
    %i[num from to].zip(
      line.scan(/\d+/).map(&:to_i)
    )
  ]
end

picture_lines = picture.split("\n")
stack_lines = picture_lines[0..-2].reverse
stack_count = picture_lines.last.scan(/\d+/).last.to_i

stacks = []
stack_count.times do |stack_num|
  stack = []
  stack_lines.each do |stack_line|
    item = stack_line[stack_num*4+1]
    stack << item if item != ' '
  end
  stacks << stack
end

# Part 1
moves.each do |move|
  move[:num].times do
    from = stacks[move[:from]-1]
    to   = stacks[move[:to  ]-1]
    to.push(from.pop)
  end
end
puts stacks.map { |s| s.last }.join

# Part 2

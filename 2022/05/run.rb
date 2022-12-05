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

# Part 1: reverse as you pop and push
# Part 2: don't reverse
[:reverse, :to_a].each do |order|
  copy = stacks.map(&:dup)
  moves.each do |move|
    from = copy[move[:from]-1]
    to   = copy[move[:to  ]-1]
    to.push(*from.pop(move[:num]).send(order))
  end
  puts copy.map { |s| s.last }.join
end

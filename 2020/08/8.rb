program = ARGF.read.split("\n")

def run(program)
  line = 0
  val = 0
  lines_run = []
  while line < program.count
    raise "infinite loop at line #{line}, accumulated value #{val}" if lines_run.include?(line)
    lines_run << line
    cmd, arg = program[line].split(' ')
    case cmd
    when 'acc' then val += arg.to_i
    when 'jmp' then line += arg.to_i - 1
    end
    line += 1
  end
  val
end

# part 1
begin
  run(program)
rescue => e
  puts e.message
end

# part 2
program.each_with_index do |line, i|
  cmd, arg = line.split(' ')
  next unless %w[jmp nop].include?(cmd)
  alt_cmd = (%w[jmp nop] - [cmd]).first
  modprog = program.map { |line| line.dup }
  modprog[i].gsub!(cmd, alt_cmd)
  begin
    val = run(modprog)
    puts "Change line #{i} from #{cmd} to #{alt_cmd} to fix the program! Accumulator ends with #{val}"
  rescue
    # nope, try something else
  end
end

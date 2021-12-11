$language = <<-STR.split("\n").map { |line| line.split.yield_self { |a| { open: a[0], close: a[1], value: a[2].to_i } } }
( ) 3
[ ] 57
{ } 1197
< > 25137
STR

$openings = $language.map { |pair| pair[:open] }
$closings = Hash[$language.map { |pair| [pair[:close], pair[:open]] }]
$scorings = Hash[$language.map { |pair| [pair[:close], pair[:value]] }]

def line_error(line)
  stack = []
  score = 0
  line.chars.each do |char|
    if $openings.include?(char)
      stack.push(char)
      nil
    elsif $closings.keys.include?(char)
      if $closings[char] == stack.last
        stack.pop
        nil
      else
        score = $scorings[char]
        break
      end
    end
  end
  score
end

lines = File.read(ARGV[0]).split("\n")
scores = lines.map do |line|
  line_error(line)
end
puts scores.sum

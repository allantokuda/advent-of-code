lines = File.read(ARGV[0]).split("\n")

$pairs = Hash[['()', '[]', '{}', '<>'].map { |pair| pair.chars }]

$error_scorings = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }
$comp_scorings = { ')' => 1, ']' => 2, '}' => 3, '>' => 4 }

def parse(line)
  stack = []
  error_score = 0
  line.chars.each do |char|
    if $pairs.keys.include?(char)
      stack.push(char)
      nil
    elsif $pairs.values.include?(char)
      if char == $pairs[stack.last]
        stack.pop
        nil
      else
        return [$error_scorings[char], nil]
      end
    end
  end
  completion_score = stack.reverse.map { |c| $pairs[c] }.inject(0) { |res, char| res * 5 + $comp_scorings[char] }
  [nil, completion_score]
end

results = lines.map { |line| parse(line) }

# Part 1
puts results.map(&:first).compact.sum

# Part 2
puts results.map(&:last).compact.sort.yield_self { |r| r[r.count/2] }

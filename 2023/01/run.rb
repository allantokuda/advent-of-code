lines = ARGF.read.split("\n")

digit_pair_to_number = ->(digit_pair) { digit_pair.first * 10 + digit_pair.last }

# Part 1
puts lines.map { |line| line.scan(/[0-9]/).map(&:to_i) }
          .map(&digit_pair_to_number)
          .sum

# Part 2
number_words = Hash[
  ('1'..'9').zip(1..9) +
  %w[one two three four five six seven eight nine].zip(1..9)
]

# convert to regex and then use hash above to look up integer value.
# (?= ) is a lookahead allowing overlapping matches
regex = /(?=(#{number_words.keys.join('|')}))/

puts lines.map { |line| line.scan(regex).flatten.map(&number_words) }
          .map(&digit_pair_to_number)
          .sum

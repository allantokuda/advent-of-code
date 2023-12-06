lines = ARGF.read.split("\n")

digit_pair_to_number = ->(digit_pair) { digit_pair.first * 10 + digit_pair.last }

# Part 1
puts lines.map { |line| line.scan(/[0-9]/).map(&:to_i) }
          .map(&digit_pair_to_number)
          .sum

# Part 2
number_words = {
  '1'   => 1, '2'   => 2, '3'     => 3, '4'    => 4, '5'    => 5, '6'   => 6, '7'     => 7, '8'     => 8, '9'    => 9,
  'one' => 1, 'two' => 2, 'three' => 3, 'four' => 4, 'five' => 5, 'six' => 6, 'seven' => 7, 'eight' => 8, 'nine' => 9,
}

# convert to regex and then use hash above to look up integer value.
# (?= ) is a lookahead allowing overlapping matches
regex = /(?=(#{number_words.keys.join('|')}))/

puts lines.map { |line| line.scan(regex).flatten.map { |item| number_words[item] } }
          .map(&digit_pair_to_number)
          .sum

# Also can do the gsub in vim:  :%s/\n\(\w\)/\1/g

# Preprocess into array of hashes
docs = File.read('input4').gsub(/\n(\w)/, ' \1').split("\n").map { |line| Hash[line.split(' ').map { |word| word.split(':') }] }

puts 'PART 1'
valid = docs.select { |doc| %w[byr ecl eyr hcl hgt iyr pid].all? { |item| doc.key?(item) } }
puts valid
puts valid.count
puts

puts 'PART 2'
valid2 = valid.select do |doc|
  [
    (1920..2002).include?(doc['byr'].to_i), # Birth Year
    (2010..2020).include?(doc['iyr'].to_i), # Issue Year
    (2020..2030).include?(doc['eyr'].to_i), # Expiration Year
    (
      /cm\z/.match?(doc['hgt']) && (150..193).include?(doc['hgt'].to_i) ||
      /in\z/.match?(doc['hgt']) && (59..76).include?(doc['hgt'].to_i)
    ), # Height
    /#[0-9a-f]{6}/.match?(doc['hcl']), # Hair Color
    %w[amb blu brn gry grn hzl oth].include?(doc['ecl']), # Eye Color
    /\A\d{9}\z/.match?(doc['pid']), # Passport ID
  ].all?
end
puts valid2
puts valid2.count
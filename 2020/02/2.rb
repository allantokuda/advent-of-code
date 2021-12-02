regex = /(\d+)-(\d+) (\w): (\w+)/
data = File.readlines('pw').map { |line| regex.match(line).captures }

# part 1
data.count { |min, max, letter, password| password.count(letter).between?(min.to_i, max.to_i) }

# part 2
data.count { |i, j, letter, password| (password[i.to_i-1] == letter) ^ (password[j.to_i-1] == letter) }


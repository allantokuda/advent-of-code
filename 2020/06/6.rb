groups = ARGF.read.split("\n\n")

# part 1: anyone
puts groups.map { |g|
  g.gsub("\n",'').
    split('').
    sort.uniq.count
}.inject(0) { |sum, n| sum + n }

# part 2: everyone
puts groups.map { |g|
  g.split("\n").
    map { |p| p.split('') }.
    inject(('a'..'z').to_a) { |overlap, person| overlap & person }.
    count
}.inject(0) { |sum, n| sum + n }
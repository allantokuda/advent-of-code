lines = File.read(ARGV[0]).split("\n").map { |line| line.split(" ") }

# part 1
scoring1 = {
  'A,Y' => 6,
  'B,Z' => 6,
  'C,X' => 6,

  'A,X' => 3,
  'B,Y' => 3,
  'C,Z' => 3,

  'A,Z' => 0,
  'B,X' => 0,
  'C,Y' => 0,
}
scoring2 = {
  'X' => 1,
  'Y' => 2,
  'Z' => 3,
}

scores = lines.map do |a, b|
  key = [a,b].join(',')
  scoring1[key] + scoring2[b]
end
puts scores.sum



# part 2
scoring3 = {
  'A,X' => 0+3, # lose rock scissors
  'B,X' => 0+1, # lose paper rock
  'C,X' => 0+2, # lose scissors paper

  'A,Y' => 3+1, # draw rock rock
  'B,Y' => 3+2, # draw paper paper
  'C,Y' => 3+3, # draw scissors scissors

  'A,Z' => 6+2, # win rock paper
  'B,Z' => 6+3, # win paper scissors
  'C,Z' => 6+1, # win scissors rock
}

scores = lines.map do |a, b|
  key = [a,b].join(',')
  scoring3[key]
end
puts scores.sum

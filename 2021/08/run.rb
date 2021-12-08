require 'ostruct'

class String
  def sort_letters
    chars.sort.join
  end
  def minus(other_string)
    (chars - other_string.chars).join
  end
end

lines = File.read(ARGV[0]).split("\n").map do |line|
  line.split(' | ').map { |half| half.split.map(&:sort_letters) }.yield_self do |halves|
    OpenStruct.new({
      pattern: halves.first.sort_by(&:length),
      output: halves.last
    })
  end
end

# part 1: count the easy digits 1,7,4,8 based on their unique segment counts (shortcut)
puts lines.map(&:output).flatten.count { |p| [2,3,4,7].include? p.length }

# part 2: decoding the scrambled segments
def decode(line)
  n1, n7, n4, u51,u52,u53, u61,u62,u63, n8 = line.pattern
  n235 = [u51, u52, u53]
  n069 = [u61, u62, u63]

  n3 = n235.find { |n| n.minus(n1).length == 3 }
  n6 = n069.find { |n| n.minus(n1).length == 5 }

  n25 = n235 - [n3]
  n09 = n069 - [n6]

  n9, n0 = n09.sort_by { |n| n.minus(n3).length }
  segment_e = n0.minus(n9)
  n2, n5 = n25.sort_by { |n| n.minus(segment_e).length }

  key = Hash[[n0, n1, n2, n3, n4, n5, n6, n7, n8, n9].each_with_index.to_a]
  line.output.map { |code| key[code] }.join.to_i
end

puts lines.map { |line| decode(line) }.sum

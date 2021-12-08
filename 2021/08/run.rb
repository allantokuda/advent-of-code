require 'ostruct'

class String
  def sort_letters
    split('').sort.join
  end
end

lines = File.read(ARGV[0]).split("\n").map do |line|
  line.split(' | ').map { |half| half.split.map(&:sort_letters) }.yield_self do |halves|
    OpenStruct.new({
      pattern: halves.first,
      output: halves.last
    })
  end
end

# part 1
puts lines.map(&:output).flatten.count { |p| [2,3,4,7].include? p.length }

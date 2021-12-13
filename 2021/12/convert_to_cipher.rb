paths = File.readlines(ARGV[0], chomp: true).map { |line| line.split('-') }

class String
  def is_big?
    self == self.capitalize
  end
end

puts 'CREATE' + [
  paths.flatten.uniq.map do |node|
    labels = if ['start', 'end'].include?(node)
             node.capitalize
           elsif node.is_big?
             'BigCave'
           else
             'SmallCave'
           end
    "(#{node}:#{labels} {name: '#{node}'})"
  end.to_a +
  paths.map do |path|
    path.reverse! if path.last == 'start' || path.first == 'end'
    path.map { |node| "(#{node})" }.join('-[:path]->')
  end.to_a
].join(",\n") + ';'
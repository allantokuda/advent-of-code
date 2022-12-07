dirs = { [:root] => 0 }
current_path = []

ARGF.read.split("\n").each do |line|
  case line
  when /\$ cd (.+)/
    dirname = $1
    case dirname
    when '/' then current_path = [:root]
    when '..' then current_path.pop
    else current_path.push(dirname)
    end

  when '$ ls'
    # no-op for now

  when /\$ dir (.+)/
    # note that this is a directory
    dirs[$1] = 0

  when /(\d+) (.+)/
    size, filename = $1.to_i, $2
    current_path.count.times do |i|
      dirs[current_path[0..i]] ||= 0
      dirs[current_path[0..i]] += size
    end

  end
end

sizes = dirs.values # only need to work with sizes for this puzzle

# Part 1
puts sizes.select { |s| s <= 100000 }.sum

# Part 2:
# amount occupied plus system update requirement minus total disk size
amount_to_delete = dirs[[:root]] + 30000000 - 70000000
puts sizes.select { |s| s >= amount_to_delete }.min
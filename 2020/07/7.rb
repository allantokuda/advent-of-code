rules = ARGF.read.split("\n")

# part 1: containers of shiny gold
paths = {}
rules.each do |rule|
  outer_color, inners = rule.gsub(/ bags?\.?/, '').split(' contain ')
  inners.split(', ').each do |inner|
    begin
      count, inner_color = inner.match(/\A(\d+)? ([a-z ]+)/).captures
    rescue
      next # no other
    end
    paths[inner_color] ||= []
    paths[inner_color].push({ color: outer_color, count: count })
  end
end

def ancestors(key, paths)
  colors = (paths[key] || []).map { |p| p[:color] }
  return (colors + colors.map { |color| ancestors(color, paths) }.flatten).sort.uniq
end

puts ancestors('shiny gold', paths).count


# part 2: contained in shiny gold
paths = {}
rules.each do |rule|
  outer_color, inners = rule.gsub(/ bags?\.?/, '').split(' contain ')
  paths[outer_color] = inners.split(', ').map do |inner|
    begin
      count, inner_color = inner.match(/\A(\d+)? ([a-z ]+)/).captures
      { count: count, color: inner_color }
    rescue
      next # no other
    end
  end.compact
end

def descendants(color, paths)
  (paths[color] || []).inject(1) { |sum, child| sum + descendants(child[:color], paths) * child[:count].to_i  }
end

puts descendants('shiny gold', paths) - 1
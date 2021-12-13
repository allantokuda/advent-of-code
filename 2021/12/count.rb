lines = File.readlines(ARGV[0], chomp: true).map { |line| line.split(',') }

class String
  def is_big?
    self == self.capitalize
  end
end

# Count paths that cross at most one small cave (lowercase)
result = lines.select do |line|
  line.sort.inject(Hash.new(0)) { |h, e| h[e] += 1; h }.to_a.reject { |pair| pair.first.is_big? }.count { |pair| pair.last > 1 } <= 1
end.count


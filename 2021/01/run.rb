numbers = File.read(ARGV[0]).split("\n").map(&:to_i)

# part 1
puts (1...numbers.count).select {|i| numbers[i] > numbers[i-1] }.count

# part 2
def window(array, i_center); array[i_center-1 .. i_center+1].sum; end
puts (2...numbers.count-1).select {|i| window(numbers, i) > window(numbers, i-1) }.count

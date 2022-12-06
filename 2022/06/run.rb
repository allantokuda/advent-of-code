str = ARGF.read

# A "marker" in a string is defined as the first index at which
# n characters leading up to that index are all different.
def find_marker(str, n)
  buffer = str[0] * n
  str.chars.each_with_index do |char, i|
    buffer = (buffer + char)[-n..-1]
    return i + 1 if buffer.chars.uniq.count == n
  end
end

puts find_marker(str,  4) # Part 1
puts find_marker(str, 14) # Part 2
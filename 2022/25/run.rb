lines = ARGF.read.split("\n")

nums = lines.map do |line|
  digits = line.chars.map do |char|
    case char
    when '-' then -1
    when '=' then -2
    else char.to_i
    end
  end
  digits.zip((0...digits.count).to_a.reverse).sum do |value, power|
    value * 5**power
  end
end

def to_snafu(base10_number)
  charmap = '012=-'
  snafu_str = ''
  remaining = base10_number
  (0..).each do |power|
    mod = remaining % 5
    snafu_str = charmap[mod] + snafu_str
    snafu_digit_value = ((mod + 2) % 5) - 2
    remaining -= snafu_digit_value
    remaining /= 5
    break if remaining == 0
  end
  snafu_str
end

# Part 1
target_val = nums.sum
puts to_snafu(target_val)

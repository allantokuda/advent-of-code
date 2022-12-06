chars = ARGF.read.chars

last4 = ''
chars.each_with_index do |char, i|
  last4 += char
  last4 = last4[1..] if last4.length == 5
  if last4.length == 4 && last4.chars.uniq.join == last4
    puts i + 1
    break
  end
end

last14 = ''
chars.each_with_index do |char, i|
  last14 += char
  last14 = last14[1..] if last14.length == 15
  if last14.length == 14 && last14.chars.uniq.join == last14
    puts i + 1
    break
  end
end
nums = ARGF.readlines.map(&:to_i)
prelen = 25

# part 1
puts breaknum = nums[
  (prelen...nums.length).detect do |i|
    prev = nums[i-prelen..i-1]
    allowed = prev.product(prev).map { |n,m| n+m }.sort.uniq
    !allowed.include? nums[i]
  end
]

# part 2
(2..32).each do |seqlen|
  (0..nums.length - seqlen).each do |start|
    set = nums[start...start + seqlen]
    if set.sum == breaknum
      puts set.min + set.max
      break
    end
  end
end

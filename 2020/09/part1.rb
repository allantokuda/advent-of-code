nums = ARGF.readlines.map(&:to_i)

def findbreak(nums, prelen)
  nums[
    (prelen...nums.length).detect do |i|
      prev = nums[i-prelen..i-1]
      allowed = prev.product(prev).map { |n,m| n+m }.sort.uniq
      !allowed.include? nums[i]
    end
  ]
end

puts findbreak(nums, 25)

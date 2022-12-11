# Usage:
#   ruby run.rb input 20 3     # part 1
#   ruby run.rb input 10000 1  # part 2
Item = Struct.new(:value)

class Monkey
  attr_reader :id, :items, :operation, :test, :inspection_count, :divisor
  def initialize(text)
    lines = text.split("\n")
    @id = lines[0].scan(/\d+/).first
    @items = lines[1].scan(/\d+/).map { |value| Item.new(value.to_i) }
    _operand1, operator, operand2 = lines[2].split(' = ').last.scan(/[^ ]+/)
    @operator = operator.to_sym
    @operand2 = operand2
    @divisor = lines[3].scan(/\d+/).first.to_i
    @true_monkey = lines[4].scan(/\d+/).first.to_i
    @false_monkey = lines[5].scan(/\d+/).first.to_i
    @inspection_count = 0
  end

  def throw_all(round_divisor, grand_mod)
    thrown_items, @items = items, []
    thrown_items.map do |item|
      operand1 = item.value
      operand2 = @operand2 == 'old' ? item.value : @operand2.to_i
      item.value = ([operand1, operand2].inject(@operator.to_sym) / round_divisor) % grand_mod
      to_monkey = item.value % @divisor == 0 ? @true_monkey : @false_monkey
      @inspection_count += 1
      [to_monkey, item]
    end
  end

  def catch(item)
    items << item
  end
end

monkeys = File.read(ARGV[0]).split("\n\n").map { |text| Monkey.new(text) }
round_count = ARGV[1].to_i
worry_divisor = ARGV[2].to_i

# Keep the number size down :)
grand_mod = monkeys.map(&:divisor).inject(:*)

round_count.times do |round|
  monkeys.each do |monkey|
    monkey.throw_all(worry_divisor, grand_mod).each do |to_monkey, item|
      monkeys[to_monkey].catch(item)
    end
  end
end
puts monkeys.map(&:inspection_count).sort.reverse.first(2).inject(:*)
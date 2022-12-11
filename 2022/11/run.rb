Item = Struct.new(:value)

class Monkey
  attr_reader :id, :items, :operation, :test, :inspection_count
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

  def throw_all
    puts "Monkey #{id} starts with #{items.map(&:value).join(',')}"
    thrown_items, @items = items, []
    thrown_items.map do |item|
      operand1 = item.value
      operand2 = @operand2 == 'old' ? item.value : @operand2.to_i
      #puts [operand1, @operator, operand2].map(&:inspect).join(' ')
      #puts ">>> #{item.value} #{operand1} #{@operator} #{@operand2.inspect} #{operand2.inspect}"
      item.value = [operand1, operand2].inject(@operator.to_sym) / 3
      #puts "<<< #{item.value}"
      #puts ["????", item.value, @divisor, @true_monkey, @false_monkey].map(&:inspect).join(' | ')
      to_monkey = item.value % @divisor == 0 ? @true_monkey : @false_monkey
      puts "Monkey #{id} throws item valued #{item.value} to monkey #{to_monkey}"
      @inspection_count += 1
      [to_monkey, item]
    end
  end

  def catch(item)
    puts "Monkey #{id} caught #{item.value} and now has: #{items.map(&:value).inspect}"
    items << item
  end
end

monkeys = ARGF.read.split("\n\n").map { |text| Monkey.new(text) }

20.times do |round|
  puts '---------'
  puts "ROUND #{round}"
  #puts monkeys.map(&:inspect)
  monkeys.each do |monkey|
    monkey.throw_all.each do |to_monkey, item|
      monkeys[to_monkey].catch(item)
    end
  end
end


puts monkeys.map(&:inspection_count).sort.reverse.first(2)
puts monkeys.map(&:inspection_count).sort.reverse.first(2).inject(:*)
class DeterministicDie
  attr_reader :val, :rolls
  def initialize
    @val = 0
    @rolls = 0
  end

  def roll
    @rolls += 1
    @val = @val % 100 + 1 # return
  end
end

class Player
  attr_accessor :score, :pos
  attr_reader :id
  def initialize(id, pos)
    @id = id
    @pos = pos
    @score = 0
  end
end

pos1, pos2 = File.read(ARGV[0]).split("\n").map { |line| line.split.last.to_i }

def circular_move(pos, dist)
  (pos + dist - 1) % 10 + 1
end

# Part 1
die = DeterministicDie.new
players = [Player.new(1, pos1), Player.new(2, pos2)]
winner = nil
loser = nil
while 1
  players.each do |player|
    dist = (1..3).map { die.roll }.sum % 10
    player.pos = circular_move(player.pos, dist)
    player.score += player.pos
    #puts "Player #{player.id} moves to space #{player.pos} for a total score of #{player.score}"
    if player.score >= 1000
      loser, winner = players.sort_by(&:score)
      break
    end
  end
  break if winner
end

puts "Part 1: Deterministic Die: #{loser.score * die.rolls}"

# Part 2
# All the different distances your pawn can move as a result of 3 rolls of a 1-2-3 die,
# and how many different roll combinations create each outome.
# Can be computed like this:
# (1..3).to_a.yield_self { |a| a.product(a).product(a) }.map(&:flatten).map(&:sum).sort.inject(Hash.new(0)) { |h,e| h[e] += 1; h }
$combination_multiplier = { 3=>1, 4=>3, 5=>6, 6=>7, 7=>6, 8=>3, 9=>1 }

def split_universe(pos, turn_count = 0, score = 0, universes = 1, outcome = {}, history = [])
  o = outcome[turn_count] ||= { win: 0, yet: 0 }
  if score >= 21
    before = o[:win]
    o[:win] += universes
    return
  else
    o[:yet] += universes
  end
  (3..9).each do |roll|
    new_pos = circular_move(pos, roll)
    split_universe(new_pos, turn_count + 1, score + new_pos, universes * $combination_multiplier[roll], outcome, history + [new_pos])
  end
  outcome
end

p1, p2 = [pos1, pos2].map { |init| split_universe(init) }

p1wins = p1.map { |tnum, data| tnum == 0 ? data[:win] : data[:win] * p2[tnum-1][:yet] }.sum
p2wins = p2.map { |tnum, data| tnum == 0 ? data[:win] : data[:win] * p1[tnum][:yet] }.sum

puts 'Part 2: Quantum die that splits the universe:'
puts "- Player 1 wins in #{p1wins} in universes"
puts "- Player 2 wins in #{p2wins} in universes"
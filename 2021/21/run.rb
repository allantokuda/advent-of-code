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

die = DeterministicDie.new
players = [Player.new(1, pos1), Player.new(2, pos2)]
winner = nil
loser = nil

while 1
  players.each do |player|
    dist = (1..3).map { die.roll }.sum % 10
    player.pos = (player.pos + dist - 1) % 10 + 1
    player.score += player.pos
    #puts "Player #{player.id} moves to space #{player.pos} for a total score of #{player.score}"
    if player.score >= 1000
      loser, winner = players.sort_by(&:score)
      break
    end
  end
  break if winner
end

# Part 1
puts loser.score * die.rolls
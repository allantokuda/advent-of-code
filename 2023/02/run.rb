games = ARGF.read.split("\n").map do |line|
  line.split(': ').then do |game_heading, game_data|
    [
      game_heading.match(/\d+/).to_s.to_i,
      game_data.split('; ').map do |round_data|
        Hash[
          round_data.split(', ').map do |color_count|
            color_count.split(' ').reverse.then do |color, count|
              [color, count.to_i]
            end
          end
        ]
      end
    ]
  end
end

# Part 1: find games with impossible rounds, given a known set of cubes of each color,
# representing the answer as a sum of game numbers
actual_counts = { 'red' => 12, 'green' => 13, 'blue' => 14 }
puts begin
  games.reject do |game_number, rounds|
    rounds.any? do |round|
      round.any? do |color, count|
        count > actual_counts[color]
      end
    end
  end.map(&:first).sum
end

# Part 2: find minimum number of cubes of each color were present in each game.
# representing the answer as a sum of products
puts begin
  games.sum do |game_number, rounds|
    %w[red green blue].map do |color|
      rounds.map do |round|
        round[color] || 0
      end.max
    end.inject(:*)
  end
end
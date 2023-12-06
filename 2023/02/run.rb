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

# Part 1

actual_counts = { 'red' => 12, 'green' => 13, 'blue' => 14 }

puts (
  games.reject do |game_number, rounds|
    rounds.any? do |round|
      round.any? do |color, count|
        count > actual_counts[color]
      end
    end
  end.map(&:first).sum
)
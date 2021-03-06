require 'ostruct'

class OctopusFlashMapper
  attr_reader :width, :length, :grid, :flash_count, :step_num

  def load(file)
    @grid = File.read(file).split("\n").map { |line| line.chars.map { |c| c.to_i } }
    @length = @grid.count
    @width = @grid.first.count
    @flash_count = 0
    @step_num = 0
  end

  def apply
    length.times do |i|
      width.times do |j|
        yield i, j
      end
    end
  end

  def neighbors(i, j)
    (-1..1)
      .to_a
      .yield_self { |range| range.product(range) }
      .reject { |d| d == [0,0] }
      .map { |di, dj| [i + di, j + dj] }
      .select { |ni, nj| (0...length).include?(ni) && (0...width).include?(nj) }
  end

  def step
    @step_num += 1
    apply { |i,j| grid[i][j] += 1 }
    apply { |i,j| flash(i, j) }
  end

  def flash(i, j)
    return unless grid[i][j] >= 10
    grid[i][j] = 0
    @flash_count += 1
    neighbors(i, j).each do |ni, nj|
      next if grid[ni][nj] == 0
      grid[ni][nj] += 1
      flash(ni, nj)
    end
  end

  def pretty
    (0...length).map do |i|
      grid[i].map { |v| '0 ⠄⠄⠆⠦⠶⠷⠿⡿⣿'[v] }.join(' ')
    end.join("\n") + "\n\n"
  end

  def all_flashed?
    @grid.flatten.uniq == [0]
  end
end

mapper = OctopusFlashMapper.new
mapper.load(ARGV[0])

# Part 1 solution
100.times { mapper.step }

# Part 2 solution
puts mapper.flash_count
until mapper.all_flashed?
  mapper.step
end
puts mapper.step_num

# Animate another copy
mapper = OctopusFlashMapper.new
mapper.load(ARGV[0])
until mapper.all_flashed?
  mapper.step
  puts mapper.pretty
  sleep 0.1
end
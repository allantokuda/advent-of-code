lines = File.read(ARGV[0]).split("\n").map(&:strip)
calls = lines.shift.split(',').map(&:to_i)
lines.map! { |l| l.split(/\s+/).map(&:to_i) }.reject!(&:empty?)
boards = lines.each_slice(5).to_a

def rowbingo(boardstate)
  boardstate.any? { |row| row.all? }
end

def vertibingo(boardstate)
  rowbingo(boardstate.transpose)
end

def diagobingo(boardstate)
  (0..4).all? { |i| boardstate[i][i] } ||
  (0..4).all? { |i| boardstate[i][4-i] }
end

def bingo(boardstate)
  [:rowbingo, :vertibingo, :diagobingo].any? { |m| send(m, boardstate) }
end

def apply(board, boardstate, num)
  board.each_with_index.map do |row, ri|
    row.each_with_index.map do |cell, ci|
      boardstate[ri][ci] = true if board[ri][ci] == num
    end
  end
end

def bingo_run(board, calls)
  boardstate = board.map { |line| line.map { false } }
  calls.each_with_index do |call, i|
    apply(board, boardstate, call)
    if bingo(boardstate)
      return [i, call, board, boardstate, prettyboard(board, boardstate), calc_board_value(board, boardstate, call)]
    end
  end
  return nil
end

def calc_board_value(board, boardstate, call)
  boardstate.each_with_index.map do |row, ri|
    row.each_with_index.map do |marked, ci|
      marked ? 0 : board[ri][ci]
    end
  end.flatten.inject(&:+) * call
end

# DEBUG
def prettyboard(board, boardstate)
  board.each_with_index.map do |row, ri|
    row.each_with_index.map do |cell, ci|
      '%8s' % (boardstate[ri][ci] ? "[#{cell}]" : " #{cell} ")
    end.join
  end.join("\n")
end

# part 1
puts boards.map { |board| bingo_run(board, calls) }.sort.first.last

# part 2
puts boards.map { |board| bingo_run(board, calls) }.sort.last.last

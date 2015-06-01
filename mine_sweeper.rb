require 'byebug'


class Game

  def self.new_game
    Game.new
  end

  def self.load_game(game)
    YAML.load(game).play
  end

  attr_accessor :board
  def initialize()
    @board = Board.new
    play
  end

  def play
    until won? || lost?
      @board.display_board
      move_type = get_move_type
      player_move = get_move ##ex. [0, 0]
      @board.update_board(player_move, move_type)
    end

    @board.display_board
    won? ? puts("YOU WINN!!!") : puts("Sorry try again")
  end

  def lost?
    @board.losing_board?
  end

  def won?
    @board.winning_board?
  end

  def get_move
    loop do
      move = []
      print "Row:  "
      move << gets.chomp.to_i
      print "Col:  "
      move << gets.chomp.to_i
      break if move.all? { |m| (0..8).to_a.include?(m) }
      puts "please use numbers between 0 and 8"
    end

    move
  end

  def get_move_type
    move_type = nil
    loop do
      print "Flag or Reveal (F/R):  "
      move_type = gets.chomp.upcase.to_sym
      break if move_type == :F || move_type == :R
    end

    move_type
  end
end

class Board
  BOARD_SIZE = 9
  NEIGHBORS = [
    [1, 0],
    [1, 1],
    [0, 1],
    [1, -1],
    [-1, 0],
    [-1, -1],
    [0, -1],
    [-1, 1]
  ]

  attr_accessor :grid
  def initialize
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE, Cell.new) }
    init_neighbors
    init_values
  end

  def init_neighbors
    @grid.each_with_index do |row, idx1|
      row.each_with_index do |cell, idx2|
        NEIGHBORS.each do |neighbor|
          rel_row = idx1 + neighbor[0]
          rel_col = idx2 + neighbor[1]
          if (0..8).to_a.include?(rel_row) && (0..8).to_a.include?(rel_col)
            cell.neighbors << @grid[rel_row][rel_col]
          end
        end
      end
    end

    nil
  end

  def init_values
    @grid.each do |row|
      row.each do |cell|
        cell.neighbors.each do |neighbor|
          cell.value += 1 if neighbor.bomb == true
        end
      end
    end

    nil
  end

  def update_board(move, move_type)
    row = move[0]
    col = move[1]

    if move_type == :R
      @grid[row][col].reveal
    else
      @grid[row][col].flagged = true
    end

    nil
  end

  def display_board
    @grid.each do |row|
      row.each do |cell|
        if cell.revealed
          cell.value > 0 ? print(cell.value) : print("_")
        else
          if cell.flagged
            print "F"
          else
            print "*"
          end
        end
        print " "
      end
      print "\n"
    end

    nil
  end

  def winning_board?
    @grid.all? do |row|
      row.all? { |cell| cell.revealed || cell.flagged }
    end
  end

  def losing_board?
    @grid.any? do |row|
      row.any? { |cell| cell.revealed && cell.bomb }
    end
  end

end


class Cell
  attr_accessor :value, :bomb, :neighbors, :flagged, :revealed

  def initialize
    @value = 0
    @bomb = set_bomb?
    @flagged = false
    @revealed = false
    @neighbors = []
  end



  def set_bomb?
    rand(7) == 0
  end

  def reveal
    @revealed == true
    unless @bomb == true || @value > 0
      @neighbors.each do |neighbor|
        neighbor.reveal
      end
    end

    nil
  end

end










#

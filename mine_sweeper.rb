
class Game

  def self.new_game
    Game.new
  end

  # def self.load_game(game)
  #
  #   YAML.load(game).play
  # end



  def initialize()
    @board = Board.new


    # play
  end

  def play
    until won? || lost?
      @board.display
      player_move = get_move ##ex. [0, 0]
      @board.check_move(player_move)

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



end

class Board
  BOARD_SIZE = 9
  NEIGHBORS = [
    [1, 0]
    [1, 1]
    [0, 1]
    [1, -1]
    [-1, 0]
    [-1, -1]
    [0, -1]
    [-1, 1]
  ]

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
          unless (0..8).to_a.include?(rel_row) && (0..8).to_a.include?(rel_col)
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

  def update_board


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
  attr_accessor :value, :bomb, :neighbors, :flagged

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

end










#

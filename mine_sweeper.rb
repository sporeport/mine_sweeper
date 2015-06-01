
class Game



  def self.new_game
    Game.new
  end

  # def self.load_game(game)
  #
  #   YAML.load(game).play
  # end



  BOARD_SIZE = 9

  def initialize()
    @board = init_board
    # play
  end



  def init_board
    Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE, Cell.new) }
  end

  def play
  end

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

  def init_neighbors
    @board.each_with_index do |row, idx1|
      row.each_with_index do |cell, idx2|
        NEIGHBORS.each do |neighbor|
          rel_row = idx1 + neighbor[0]
          rel_col = idx2 + neighbor[1]
          unless (0..8).to_a.include?(rel_row) && (0..8).to_a.include?(rel_col)
            cell.neighbors << @board[rel_row][rel_col]
          end
        end
      end
    end

    nil
  end

  def init_values
    @board.each do |row|
      row.each do |cell|
        cell.neighbors.each do |neighbor|
          cell.value += 1 if neighbor.bomb == true
        end
      end
    end

    nil
  end
end

class Cell
  attr_accessor :value, :bomb, :neighbors, :flag

  def initialize
    @value = 0
    @bomb = set_bomb?
    @flag = false
    @revealed = false
    @neighbors = []
  end

  def set_bomb?
    rand(7) == 0
  end

end










#

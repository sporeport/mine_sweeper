require 'yaml'


class Game

  attr_accessor :board
  def initialize
    setup_game
  end

  def setup_game
    if new_or_load == :L
      print "Game name: "
      game_name = gets.chomp
      game_state = File.read(game_name)
      @board = YAML.load(game_state)
    else
      @board = Board.new
    end

    nil
  end

  def play
    until won? || lost?
      @board.display_board

      option = get_option
      if option == :S
        save_game
      elsif option == :Q
        puts "Thanks for playing\nGoodbye!"
        return nil
      else
        player_move = get_move
        @board.update_board(player_move, option)
      end
    end
    @board.display_board
    won? ? puts("YOU WINN!!!") : puts("Sorry try again")

    nil
  end

  def lost?
    @board.losing_board?
  end

  def won?
    @board.winning_board?
  end

  def get_move
    move = []

    loop do
      print "Row:  "
      move << gets.chomp.to_i
      print "Col:  "
      move << gets.chomp.to_i
      break if Board.within_bounds(move)
      puts "please use numbers between 0 and 8"
      move.clear
    end

    move
  end

  def get_option
    option = nil

    loop do
      print "R -> Reveal : F -> Flag : S -> Save : Q -> Quit\n"
      option = gets.chomp.upcase.to_sym
      break if [:R, :F, :S, :Q].include?(option)
      print "Please type R, F, S, or Q\n"
    end

    option
  end

  def save_game
    print "Save as: "
    save_name = gets.chomp
    game_state = self.board.to_yaml
    File.open(save_name, "w") do |f|
      f.puts game_state
    end
  end

  def new_or_load
    option = nil
    loop do
      print "N -> New game : L -> Load game\n"
      option = gets.chomp.upcase.to_sym
      break if [:N, :L].include?(option)
      print "Please type N, L\n"
    end

    option
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

  def self.within_bounds(row_col) ##ex [0, 2]
    row_col.all? { |m| (0...BOARD_SIZE).to_a.include?(m) }
  end

  attr_accessor :grid, :all_cells
  def initialize
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) { Cell.new } }
    init_neighbors
    init_values
  end

  def all_cells
    @grid.flatten
  end

  def init_neighbors
    @grid.each_with_index do |row, idx1|
      row.each_with_index do |cell, idx2|
        NEIGHBORS.each do |neighbor|
          rel_row, rel_col = idx1 + neighbor[0], idx2 + neighbor[1]

          if Board.within_bounds([rel_row, rel_col])
            cell.neighbors << @grid[rel_row][rel_col]
          end
        end
      end
    end

    nil
  end

  def init_values
    all_cells.each do |cell|
      cell.neighbors.each do |neighbor|
        cell.value += 1 if neighbor.bomb?
      end
    end

    nil
  end

  def update_board(move, move_type)
    row, col = move[0], move[1]

    case move_type
    when :R
      @grid[row][col].reveal
    when :F
      @grid[row][col].flag
    end

    nil
  end

  def display_board
    print "    "
    (0..8).each { |i| print "#{i.to_s} " }
    print "\n\n"
    @grid.each_with_index do |row, idx1|
      print "#{idx1.to_s}   "
      row.each_with_index do |cell, idx2|
        if cell.revealed?
          if cell.bomb?
            print "X"
          else
            cell.value > 0 ? print(cell.value.to_s) : print("_")
          end
        else
          cell.flagged? ? print("F") : print("*")
        end
        print " "
      end
      print "\n"
    end
    print "\n"

    nil
  end

  def winning_board?
    all_cells.all? { |cell| cell.revealed? || cell.flagged? }
  end

  def losing_board?
    all_cells.any? { |cell| cell.revealed? && cell.bomb? }
  end

end


class Cell
  attr_accessor :value, :neighbors

  def initialize
    @value = 0
    @bomb = set_bomb?
    @flagged = false
    @revealed = false
    @neighbors = []
  end

  def flagged?
    @flagged
  end

  def revealed?
    @revealed
  end

  def bomb?
    @bomb
  end

  def flag
    @flagged = true
  end

  def set_bomb?
    rand(10) == 0
  end

  def reveal
    @revealed = true

    unless @bomb == true || @value > 0
      @neighbors.each do |neighbor|
        neighbor.reveal unless neighbor.revealed?
      end
    end

    nil
  end

end


game = Game.new.play







#

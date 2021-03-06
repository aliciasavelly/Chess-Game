require_relative 'board.rb'
require_relative 'display.rb'
require_relative 'humanplayer.rb'

class Game

  def initialize
    @player_one = get_player(:white)
    @player_two = get_player(:black)

    @board = Board.new
    @display = Display.new(@board)
  end

  def play
    color = :white

    until over?
      render
      take_turn(color)
      color = color == :white ? :black : :white
    end

    render

  end

  def take_turn(color)
    name = color == :white ? @player_one.name : @player_two.name

    start_pos = @display.input(name)
    end_pos = @display.input(name)
    @board.move_piece(start_pos, end_pos, color)

    rescue WrongColor => e
      puts "That's not your piece. Move your own piece!"
      sleep 1
      retry
    rescue NoPieceAtStartPosition => e
      puts "That was an empty space. Try again.        "
      sleep 1
      retry
    rescue EndPositionNotValid => e
      puts "Something's wrong with your move.          "
      sleep 1
      retry
    rescue LosingMove => e
      puts "Your King is more important than your whims!"
      sleep 1.5
      retry
  end

  def over?
    winner = @board.checkmate?(:black) ? @player_one.name : @player_two.name

    if @board.checkmate?(:white) || @board.checkmate?(:black)
      puts "#{winner} won!"
      sleep 3
      return true
    end

    false
  end

  def render
    @display.render
  end

  def get_player(color)
    puts "name?"
    HumanPlayer.new(gets.chomp, color)
  end

end

if __FILE__ == $0
  game = Game.new
  game.play
end

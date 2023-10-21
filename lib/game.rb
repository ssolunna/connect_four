# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/player'

# Game: Connect Four
class Game
  def initialize
    @board = Board.new
    @player_one = nil
    @player_two = nil
    @current_player = nil
    @winner = nil
  end

  def play
    set_players
    @board.display
    player_turns
    game_over
  end

  def set_players
    set_player_one
    set_player_two
    set_initial_player
  end

  def player_turns
    until @board.full?
      place_token(@current_player)
      @board.display

      return set_winner if player_won?

      switch_current_player
    end
  end

  def place_token(player)
    loop do
      verified_column = verify_column(player_input((1..7)))

      if verified_column
        @board.update_column(verified_column, player.token)
        break
      else
        puts 'Column is full. Pick one with empty spaces'
      end
    end
  end

  def player_won?
    @board.vertical_line? || @board.horizontal_line? || @board.diagonal_line?
  end

  def switch_current_player
    @current_player = @current_player == @player_one ? @player_two : @player_one
  end

  def game_over
    case @winner
    when @player_one then puts "#{@player_one.name} is the winner!"
    when @player_two then puts "#{@player_two.name} is the winner!"
    else
      puts "It's a draw!"
    end
  end

  def player_input(range)
    loop do
      user_input = gets.chomp
      verified_number = verify_number(range, user_input.to_i)
      return verified_number if verified_number

      puts "Invalid input"
    end
  end

  def verify_number(range, input)
    return input if range.to_a.include?(input)
  end

  def verify_column(column_number)
    return column_number unless @board.column_full?(column_number)
  end

  private

  def set_player_one
    red_token = "\e[31m\u25CF\e[0m"
    @player_one = Player.new('Player 1', red_token)
  end

  def set_player_two
    yellow_token = "\e[91m\u25CF\e[0m"
    @player_two = Player.new('Player 2', yellow_token)
  end

  def set_initial_player
    @current_player = player_input((1..2)) == 1 ? @player_one : @player_two
  end

  def set_winner
    @winner = @current_player 
  end
end

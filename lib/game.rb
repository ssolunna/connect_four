# frozen_string_literal: true

require_relative '../lib/player'

class Game
  def initialize
    @player_one = nil
    @player_two = nil
    @current_player = nil
  end

  def set_players
    set_player_one
    set_player_two
    set_initial_player
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
end

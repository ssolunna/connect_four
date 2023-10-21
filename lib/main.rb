# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/display'

# Play Game: Connect Four
def play_game
  game = Game.new
  game.play
end

play_game

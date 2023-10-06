# frozen_string_literal: true

# Connect Four Board
class Board
  @@empty_space = ' '

  def initialize
    @columns = {
      1 => Array.new(6, @@empty_space),
      2 => Array.new(6, @@empty_space),
      3 => Array.new(6, @@empty_space),
      4 => Array.new(6, @@empty_space),
      5 => Array.new(6, @@empty_space),
      6 => Array.new(6, @@empty_space),
      7 => Array.new(6, @@empty_space) 
    }
  end

  def display 
   puts <<-HEREDOC

                \e[4;1mCOLUMNS\e[0m
       1   2   3   4   5   6   7

      ---+---+---+---+---+---+---
       #{@columns[1][5]} | #{@columns[2][5]} | #{@columns[3][5]} | #{@columns[4][5]} | #{@columns[5][5]} | #{@columns[6][5]} | #{@columns[7][5]}
      ---+---+---+---+---+---+---
       #{@columns[1][4]} | #{@columns[2][4]} | #{@columns[3][4]} | #{@columns[4][4]} | #{@columns[5][4]} | #{@columns[6][4]} | #{@columns[7][4]}
      ---+---+---+---+---+---+---
       #{@columns[1][3]} | #{@columns[2][3]} | #{@columns[3][3]} | #{@columns[4][3]} | #{@columns[5][3]} | #{@columns[6][3]} | #{@columns[7][3]}
      ---+---+---+---+---+---+---
       #{@columns[1][2]} | #{@columns[2][2]} | #{@columns[3][2]} | #{@columns[4][2]} | #{@columns[5][2]} | #{@columns[6][2]} | #{@columns[7][2]}
      ---+---+---+---+---+---+---
       #{@columns[1][1]} | #{@columns[2][1]} | #{@columns[3][1]} | #{@columns[4][1]} | #{@columns[5][1]} | #{@columns[6][1]} | #{@columns[7][1]}
      ---+---+---+---+---+---+---
       #{@columns[1][0]} | #{@columns[2][0]} | #{@columns[3][0]} | #{@columns[4][0]} | #{@columns[5][0]} | #{@columns[6][0]} | #{@columns[7][0]}
      ---+---+---+---+---+---+---

   HEREDOC
  end

  # Updates the lowest available space within a column with the player's token
  def update_column(column, player_token)
    row = lowest_available_space(column)
    @columns[column][row] = player_token
  end

  private

  # Finds the column's row with the lowest available space
  def lowest_available_space(column)
    @columns[column].index(@@empty_space)
  end
end

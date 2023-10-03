# frozen_string_literal: true

# Connect Four Board
class Board
  @@empty_space = ' '

  def initialize
    @columns = create_board 
  end

  def create_board
    {
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
  def update_column(column_number, player_token)
    row = lowest_available_space(column_number)
    @columns[column_number][row] = player_token
  end

  def column_full?(column_number)
    lowest_available_space(column_number) ? false : true
  end

  # Checks if a player forms a vertical line of 4 of their own token
  def vertical_line?
    @columns.each_value do |column|
      break if less_than_four_tokens?(column)

      if column[0..3].uniq.length == 1 # at the bottom
        return true
      elsif column[1..4].uniq.length == 1 # at the middle
        return true
      elsif column[2..5].uniq.length == 1 # at the top
        return true
      end
    end

    false
  end

  # Checks if a player forms a horizontal line of 4 of their own token
  def horizontal_line?
    0.upto(5) do |row_number|
      row = Array.new

      1.upto(7) { |column| row << @columns[column][row_number] }

      break if less_than_four_tokens?(row)

      if row[0..3].uniq.length == 1 # at the beginning
        return true
      elsif row[1..4].uniq.length == 1 # in the middle
        return true
      elsif row[2..5].uniq.length == 1 # in the other middle
        return true
      elsif row[3..6].uniq.length == 1 # at the end
        return true
      end
    end

    false
  end

  private

  # Finds the column's row with the lowest available space
  def lowest_available_space(column_number)
    @columns[column_number].index(@@empty_space)
  end

  def less_than_four_tokens?(column_or_row)
    column_or_row.filter { |space| space != @@empty_space }.length <= 3
  end
end

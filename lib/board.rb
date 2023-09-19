# frozen_string_literal: true

# Connect Four Board
class Board
  attr_reader :spaces

  def initialize
    @spaces = (0...42).to_a
  end

  def show
   puts <<-HEREDOC

                   \e[4;1mCOLUMNS\e[0m
       1    2    3    4    5    6    7

      #{spaces[35]} | #{spaces[36]} | #{spaces[37]} | #{spaces[38]} | #{spaces[39]} | #{spaces[40]} | #{spaces[41]}
     ----+----+----+----+----+----+----
      #{spaces[28]} | #{spaces[29]} | #{spaces[30]} | #{spaces[31]} | #{spaces[32]} | #{spaces[33]} | #{spaces[34]}
     ----+----+----+----+----+----+----
      #{spaces[21]} | #{spaces[22]} | #{spaces[23]} | #{spaces[24]} | #{spaces[25]} | #{spaces[26]} | #{spaces[27]}
     ----+----+----+----+----+----+----
      #{spaces[14]} | #{spaces[15]} | #{spaces[16]} | #{spaces[17]} | #{spaces[18]} | #{spaces[19]} | #{spaces[20]}
     ----+----+----+----+----+----+----
       #{spaces[7]} |  #{spaces[8]} |  #{spaces[9]} | #{spaces[10]} | #{spaces[11]} | #{spaces[12]} | #{spaces[13]}
     ----+----+----+----+----+----+----
       #{spaces[0]} |  #{spaces[1]} |  #{spaces[2]} |  #{spaces[3]} |  #{spaces[4]} |  #{spaces[5]} |  #{spaces[6]}
   HEREDOC
  end
end

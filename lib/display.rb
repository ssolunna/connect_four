module Display
  def display_game_intro
    puts <<-HEREDOC 
Game: Connect Four 
Description: A game where two players take turns dropping tokens 
             into the board. Players win if they manage to get 4 
             of their token consecutively in a row, column, or 
             along a diagonal. 

    HEREDOC
  end

  def display_select_prompt(player_one, player_two)
    puts <<-HEREDOC
Select the player who will begin:

  [1] #{player_one.name} #{player_one.token}
  [2] #{player_two.name} #{player_two.token}

    HEREDOC
  end

  def display_prompt(player, range)
    if player 
      print "[#{player.token} #{player.name}] " 
      print "Place token (#{range.first}-#{range.last}): " 
    else 
      print "Enter a number (#{range.first}-#{range.last}): " 
    end
  end

  def display_err_column_full
    puts "\e[91mError: Column is full (Pick one with empty spaces)\e[0m"
    puts
  end

  def display_err_invalid_input
    puts "\e[91mError: Invalid input (Enter a number between the given range)\e[0m"
    puts
  end
end

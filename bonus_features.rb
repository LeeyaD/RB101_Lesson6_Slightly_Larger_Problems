# PROGRAM ISSUES

# keep track of 'current_player' and switch variable after every turn
#  current_player's initial value will depend on value of 'result'
# CHANGE ---> result == 'Choose' ? result = players_choice : nil
# TO -------> result == 'Choose' ? current_player = players_choice : nil

# ALSO CHANGE
# def players_choice
#   prompt "Choose who moves first! Type 1 for yourself or 2 for the Computer."
#   choice = gets.chomp
#   case choice
#   when "1"
#     'Player' <---true
#   when "2"
#     'Computer' <--- false
#   end
# end

loop do
  display_board(bpard)
  place_piece!(board, current_player)
  current_player = alternate_player(current_player)
  break if someone_won?(board) || board_full?(board)
end

def place_piece!(brd, current_player)
  case current_player
  when true
    player_places_piece!(brd)
  when false
    computer_places_piece!(brd)
  end
end

def alternate_player(current_player)
  !!current_player
end


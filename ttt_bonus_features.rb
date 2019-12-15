require 'Pry'
INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]
scoreboard = {'Player' => 0, 'Computer' => 0}

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd, scorebrd)
  system 'clear'
  prompt "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  prompt "Current score: Player #{scorebrd['Player']} | Computer #{scorebrd['Computer']}"
  puts ""
  puts "      |      |"
  puts "   #{brd[1]}  |   #{brd[2]}  |   #{brd[3]}"
  puts "      |      |"
  puts "------+------+------"
  puts "      |      |"
  puts "   #{brd[4]}  |   #{brd[5]}  |   #{brd[6]}"
  puts "      |      |"
  puts "------+------+------"
  puts "      |      |"
  puts "   #{brd[7]}  |   #{brd[8]}  |   #{brd[9]}"
  puts "      |      |"
  puts ""
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
    brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(array, delimiter = ", ", join_word = "or")
  if array.size == 1
    "#{array[0]}"
  elsif array.size == 2
    "#{array[0]} " + join_word + " #{array[1]}"
  else
    array.join(delimiter).insert(-2, join_word + " ")
  end
end

def player_places_piece!(brd)
  square = ""
  loop do
    prompt "Choose a sqaure (#{joinor(empty_squares(brd))}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice"
  end

  brd[square] = PLAYER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def update_score(scorebrd, winner)
  scorebrd[winner] += 1 unless winner == nil
end

def display_score(scorebrd)
  prompt "The score is: Player #{scorebrd['Player']}, Computer #{scorebrd['Computer']}"
end

def display_winner(scorebrd)
  prompt "#{scorebrd.key(5)} has won the game!"
end

def reset_score(scorebrd)
  scorebrd.transform_values! do |score|
    score = 0
  end
end

def computer_places_piece!(brd)
  if find_threat(brd).size == nil
    defensive_move(brd)
  else
   square = empty_squares(brd).sample
   brd[square] = COMPUTER_MARKER
  end
end

def find_threat(brd)
  WINNING_LINES.select do |line|
    brd.values_at(*line).count(PLAYER_MARKER) == 2 #&&
    binding.pry
    #brd.values_at(*line).count(INITIAL_MARKER) == 1
  end
end

def defensive_move(brd)
  line = find_threat(brd).sample
  
  line.each do |space|
      if brd[space] == INITIAL_MARKER
        brd[space] = COMPUTER_MARKER
      end
  end
end


loop do
  board = initialize_board

  loop do
    display_board(board, scoreboard)

    player_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
    
    computer_places_piece!(board)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board, scoreboard)
  
  if someone_won?(board)
    prompt "#{detect_winner(board)} won this round!"
  else
    prompt "It's a tie!"
  end

  update_score(scoreboard, detect_winner(board))
  display_score(scoreboard)
  puts ""
  sleep 2
  scoreboard.key(5) ? display_winner(scoreboard) : next
 
  reset_score(scoreboard)

  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end

prompt "Thanks for playing Tic Tac Toe! Good bye!"

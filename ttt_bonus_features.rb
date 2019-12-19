require 'io/console'
require 'pry'
require 'pry-byebug'

INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]
FIRST_MOVES = ['Player', 'Computer', 'Choose']
MAX_WINS = 5

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  prompt "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
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
    array[0].to_s
  elsif array.size == 2
    "#{array[0]} " + join_word + " #{array[1]}"
  else
    array.join(delimiter).insert(-2, join_word + " ")
  end
end

def player_places_piece!(brd)
  square = ""
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice"
  end

  brd[square] = PLAYER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def find_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return "Player"
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return "Computer"
    end
  end
  nil
end

def someone_won?(brd)
  !!find_winner(brd)
end

def update_score(scoreboard, winner)
  scoreboard[winner] += 1 unless winner.nil?
end

def display_score(scoreboard)
  prompt "Score: Player #{scoreboard['Player']} |" \
         " Computer #{scoreboard['Computer']}"
end

def display_winner(scoreboard)
  prompt "#{scoreboard.key(MAX_WINS)} has won the game!"
end

def reset_score(scoreboard)
  scoreboard.transform_values! { |_| 0 }
end

def center_square(brd)
  5 if brd[5] == INITIAL_MARKER
end

def offensive_move(brd)
  square = nil
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, COMPUTER_MARKER)
    break if square
  end
  square
end

def defensive_move(brd)
  square = nil
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, PLAYER_MARKER)
    break if square
  end
  square
end

def computer_places_piece!(brd)
  square = offensive_move(brd) || defensive_move(brd) ||
           center_square(brd) || empty_squares(brd).sample

  brd[square] = COMPUTER_MARKER
end

def find_at_risk_square(line, board, mark)
  if board.values_at(*line).count(mark) == 2
    board.select do |k, v|
      line.include?(k) && v == INITIAL_MARKER
    end.keys.first
  end
end

def who_moves_first
  result = FIRST_MOVES.sample
  case result
  when 'Choose'
    puts "Looks like you get to decide who goes first this round!"
    puts ""
    prompt "Press <enter> to continue!"
    STDIN.getch
    players_choice
  else
    puts "#{result} gets to go first!"
    puts ""
    prompt "Press <enter> to continue!"
    STDIN.getch
    result == 'Player'
  end
end

def players_choice
  choice = nil
  loop do
    prompt "Type the number 1 for yourself or 2 for the Computer."
    choice = gets.chomp.to_i
    break if choice == 1 || choice == 2
    prompt "Sorry, that's not a valid choice"
  end

  case choice
  when 1
    true
  when 2
    false
  end
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
  !current_player
end

def play_round(brd, current_player)
  loop do
    display_board(brd)
    place_piece!(brd, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(brd) || board_full?(brd)
  end
end

def round_winner(brd)
  if someone_won?(brd)
    prompt "#{find_winner(brd)} won this round!"
  else
    prompt "It's a tie!"
  end
end

def play_again?
  prompt "Play again? (y or n)"
  gets.chomp.downcase
end

scoreboard = { 'Player' => 0, 'Computer' => 0 }

system 'clear'
prompt "Welcome to Tic Tac Toe! To win the game get three in a row!"
puts ""

prompt "You're 'X' and the Computer is 'O'. You and the Computer alternate
placing Xs and Os on the game board until one of you has 3 in a row or until all
nine squares are filled. First one to win 5 rounds, wins the game!"
puts ""

prompt "The twist here is you never know who's going to go first each round!
You, the Computer or will you get the special chance to decide!"
puts ""

prompt "Press Enter or Return to begin playing!"
STDIN.getch
system 'clear'

loop do
  board = initialize_board
  system 'clear'
  current_player = who_moves_first

  play_round(board, current_player)

  display_board(board)

  round_winner(board)

  puts ""
  sleep 2
  update_score(scoreboard, find_winner(board))
  display_score(scoreboard)

  puts ""
  sleep 2
  scoreboard.key(MAX_WINS) ? display_winner(scoreboard) : next

  reset_score(scoreboard)
  puts ""
  break unless play_again? == "y"
end

prompt "Thanks for playing Tic Tac Toe! Good bye!"

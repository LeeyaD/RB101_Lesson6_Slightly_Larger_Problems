INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]
FIRST_MOVES = ['Player', 'Computer', 'Choose']
scoreboard = { 'Player' => 0, 'Computer' => 0 }

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

def update_score(scrbrd, winner)
  scrbrd[winner] += 1 unless winner.nil?
end

def display_score(scrbrd)
  prompt "Score: Player #{scrbrd['Player']} | Computer #{scrbrd['Computer']}"
end

def display_winner(scrbrd)
  prompt "#{scrbrd.key(5)} has won the game!"
end

def reset_score(scrbrd)
  scrbrd.transform_values! { |_| 0 }
end

# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/MethodLength
def computer_places_piece!(brd)
  square = nil

  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, COMPUTER_MARKER)
    break if square
  end

  if !square
    WINNING_LINES.each do |line|
      square = find_at_risk_square(line, brd, PLAYER_MARKER)
      break if square
    end
  end

  if !square
    square = 5 if brd[5] == INITIAL_MARKER
  end

  if !square
    square = empty_squares(brd).sample
  end

  brd[square] = COMPUTER_MARKER
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/CyclomaticComplexity

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
    sleep 3
    players_choice
  else
    puts "#{result} gets to go first!"
    sleep 3
    result == 'Player' ? true : false
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

system 'clear'
prompt "Welcome to Tic Tac Toe! To win the game get three in a row!"
puts ""
sleep 4
prompt "You're 'X' and the Computer is 'O'. You and the Computer alternate
placing Xs and Os on the game board until one of you has 3 in a row or until all
nine squares are filled. First one to win 5 rounds, wins the game!"
puts ""
sleep 10
prompt "The twist here is you never know who's going to go first each round!
You, the Computer or will you get the special chance to decide!"
puts ""
sleep 10
prompt "Let's begin!"
sleep 2
system 'clear'

loop do
  board = initialize_board
  system 'clear'
  current_player = who_moves_first

  loop do
    display_board(board)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    prompt "#{find_winner(board)} won this round!"
  else
    prompt "It's a tie!"
  end

  puts ""
  sleep 2
  update_score(scoreboard, find_winner(board))
  display_score(scoreboard)

  puts ""
  sleep 3
  scoreboard.key(5) ? display_winner(scoreboard) : next

  reset_score(scoreboard)
  puts ""
  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end

prompt "Thanks for playing Tic Tac Toe! Good bye!"

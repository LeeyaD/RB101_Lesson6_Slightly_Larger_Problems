require 'io/console'

WHATEVER_ONE = 21
DEALER_HITS_UNTIL = 17
MAX_WINS = 5

def prompt(message)
  puts "=> #{message}"
end

def line
  puts ""
end

def initialize_deck
  {
    'H' => ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'],
    'S' => ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'],
    'D' => ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'],
    'C' => ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
  }
end

def reset_cards(players_cards, dealers_cards)
  players_cards.clear
  dealers_cards.clear
end

def deal_card(cards, deck)
  suits = deck.keys
  selected_suit = suits.sample
  selected_card = deck[selected_suit].sample

  cards << [selected_suit, selected_card]
  deck[selected_suit].delete(selected_card)

  if deck[selected_suit].empty?
    deck.delete(selected_suit)
  end
end

def initial_deal(players_cards, dealers_cards, deck)
  2.times do
    deal_card(players_cards, deck)
  end

  2.times do
    deal_card(dealers_cards, deck)
  end
end

def total(cards)
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    sum += if value == "A"
             11
           elsif value.to_i == 0
             10
           else
             value.to_i
           end
  end

  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > 21
  end

  sum
end

def player_busted?
  @player_total > WHATEVER_ONE
end

def dealer_busted?
  @dealer_total > WHATEVER_ONE
end

def detect_result
  if @player_total > WHATEVER_ONE
    :player_busted
  elsif @dealer_total > WHATEVER_ONE
    :dealer_busted
  elsif @dealer_total < @player_total
    :player
  elsif @player_total < @dealer_total
    :dealer
  else
    :tie
  end
end

def display_results
  result = detect_result

  case result
  when :player_busted
    prompt "You busted! Dealer wins!"
  when :dealer_busted
    prompt "Dealer busted! You win!"
  when :player
    prompt "You win!"
  when :dealer
    prompt "Dealer wins!"
  else
    prompt "It's a tie!"
  end
end

def show_players_hand(players_cards)
  prompt "Your cards: #{players_cards} total #{@player_total}"
end

def players_choice
  answer = nil
  loop do
    prompt "Do you want to (h)it or (s)tay?"
    answer = gets.chomp
    break if ['h', 's'].include?(answer)
    prompt "Please enter a valid choice"
  end
  answer
end

def hit(answer, players_cards, deck)
  if answer == 'h'
    deal_card(players_cards, deck)
    @player_total = total(players_cards)

    prompt "You choose to hit!"
    show_players_hand(players_cards)
    line
  end
end

def player_turn(players_cards, dealers_cards, deck, scoreboard)
  loop do
    answer = players_choice
    hit(answer, players_cards, deck)
    break if answer == 's' || player_busted?
  end

  if player_busted?
    @dealer_total = total(dealers_cards)
    continue
    grand_output(players_cards, dealers_cards, scoreboard)
    play_again?
  else
    prompt "You choose to stay at #{@player_total}."
  end
end

def show_dealers_hand(dealers_cards)
  prompt "Dealer's cards: #{dealers_cards} total #{@dealer_total}"
end

def dealer_turn(dealers_cards, players_cards, deck, scoreboard)
  @dealer_total = total(dealers_cards)

  loop do
    break if @dealer_total >= DEALER_HITS_UNTIL || dealer_busted?
    prompt "Dealer chooses to hit!"

    deal_card(dealers_cards, deck)
    @dealer_total = total(dealers_cards)

    show_dealers_hand(dealers_cards)
    continue
  end

  if dealer_busted?
    grand_output(players_cards, dealers_cards, scoreboard)
    play_again?
  else
    prompt "Dealer chooses to stay at #{@dealer_total}"
  end
end

def display_cards_and_totals(players_cards, dealers_cards)
  show_players_hand(players_cards)
  show_dealers_hand(dealers_cards)
end

def display_initial_cards(players_cards, dealers_cards)
  @player_total = total(players_cards)

  show_players_hand(players_cards)
  prompt "Dealer's cards: #{dealers_cards[0]} and ?"
end

def play_again?
  answer = nil
  loop do
    puts "------------------------------------------------------"
    prompt "Do you want to play again? (y or n)"
    answer = gets.chomp.downcase
    break if ['y', 'n'].include?(answer)
    prompt "Please enter a valid choice"
  end
  answer.downcase == 'y'
end

def grand_output(players_cards, dealers_cards, scoreboard)
  puts "------------------------------------------------------"
  prompt "End of round!"
  display_cards_and_totals(players_cards, dealers_cards)
  sleep(2)
  line

  display_results
  update_score(scoreboard)
  display_score(scoreboard)
  line
  grand_winner(scoreboard) if scoreboard.key(5)
end

def continue
  line
  prompt "Press any key to continue"
  STDIN.getch
  line
end

def reset_score(scoreboard)
  scoreboard.transform_values! { |_| 0 } if scoreboard.key(MAX_WINS)
end

def display_score(scoreboard)
  symbols = scoreboard.keys
  names = []

  symbols.each do |el|
    names << el.to_s.capitalize
  end

  prompt "Current score - #{names[0]}: #{scoreboard[symbols[0]]} |" \
         " #{names[1]}: #{scoreboard[symbols[1]]}"
end

def update_score(scoreboard)
  players = scoreboard.keys
  result = detect_result

  if result == :player || result == :dealer_busted
    scoreboard[players[0]] += 1
  elsif result == :dealer || result == :player_busted
    scoreboard[players[1]] += 1
  end
end

def grand_winner(scoreboard)
  winner = scoreboard.key(MAX_WINS)
  prompt "#{winner.to_s.capitalize} wins the game with #{MAX_WINS} points!"
end

players_cards = []
dealers_cards = []
scoreboard = { player: 0, dealer: 0 }

system 'clear'
prompt 'Welcome to Twenty One!'
continue

loop do
  reset_cards(players_cards, dealers_cards)
  reset_score(scoreboard)
  deck = initialize_deck
  system 'clear'

  prompt 'Dealing cards...'
  sleep(1)
  line

  initial_deal(players_cards, dealers_cards, deck)
  display_initial_cards(players_cards, dealers_cards)
  line

  case player_turn(players_cards, dealers_cards, deck, scoreboard)
  when true
    next
  when false
    break
  end

  continue
  case dealer_turn(dealers_cards, players_cards, deck, scoreboard)
  when true
    next
  when false
    break
  end
  line

  grand_output(players_cards, dealers_cards, scoreboard)

  break unless play_again?
end

prompt 'Thank you for playing! Goodbye!'

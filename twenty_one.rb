require 'io/console'
require 'pry'
require 'pry-byebug'

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

def busted?(cards)
  total(cards) > 21
end

def player_turn(players_cards, dealers_cards, deck)
  answer = nil
  loop do
    prompt "Do you want to (h)it or (s)tay?"
    answer = gets.chomp
    deal_card(players_cards, deck) if answer == 'h'
    break if answer == 's' || busted?(players_cards)
    display_cards(players_cards, dealers_cards)
  end

  if busted?(players_cards)
    prompt "Oh no! You went over!"
  else
    prompt "You choose to stay. Dealer's turn!"
    line
  end
end

def dealer_turn(dealers_cards, deck)
  loop do
    break if total(dealers_cards) >= 17 || busted?(dealers_cards)
    deal_card(dealers_cards, deck)
  end

  if busted?(dealers_cards)
    sleep(1)
    prompt "Dealer went over!"
  else
    prompt 'Dealer chooses to stay!'
  end
end



def display_final_card_totals(players_cards, dealers_cards)
  prompt "Your cards: #{players_cards} " \
  "totaling #{total(players_cards)} | "
  prompt "Dealer's cards: #{dealers_cards} " \
  "totaling #{total(dealers_cards)}"
end

def display_cards(players_cards, dealers_cards)
  prompt "Your cards: #{players_cards} " \
  "totaling #{total(players_cards)}"
  prompt "Dealer's cards: #{dealers_cards[0]} and ?"
end

def player_won?(player, dealer)
  player <= 21 && player > dealer || dealer > 21 && dealer > player
end

def dealer_won?(player, dealer)
  player > 21 && player > dealer || dealer <= 21 && dealer > player
end

def compare_cards(players_cards, dealers_cards)
  player = total(players_cards)
  dealer = total(dealers_cards)

  if player_won?(player, dealer)
    'You won!'
  elsif dealer_won?(player, dealer)
    'Dealer won!'
  end
end

def declare_winner(players_cards, dealers_cards)
  results = compare_cards(players_cards, dealers_cards)
  if results
    prompt results.to_s
  else
    prompt "It's a tie!"
  end
end

def final_totals(players_cards, dealers_cards)
  sleep(1)
  prompt "The final totals are..."
  display_final_card_totals(players_cards, dealers_cards)
  line
end

def play_round(players_cards, dealers_cards, deck)
  player_turn(players_cards, dealers_cards, deck)
  return if busted?(players_cards)
  dealer_turn(dealers_cards, deck)
end

players_cards = []
dealers_cards = []

system 'clear'
prompt 'Welcome to Twenty One!'

loop do
  system 'clear'
  reset_cards(players_cards, dealers_cards)
  deck = initialize_deck

  prompt 'Dealing cards...'
  sleep(1)
  line

  initial_deal(players_cards, dealers_cards, deck)
  display_cards(players_cards, dealers_cards)
  line

  play_round(players_cards, dealers_cards, deck)
  line

  final_totals(players_cards, dealers_cards)
  sleep(2)
  line

  declare_winner(players_cards, dealers_cards)
  line

  prompt 'Would you like to play again? (y/n)' # create #play_again?
  break if gets.chomp.downcase == 'n'
end

prompt 'Thank you for playing! Goodbye!'

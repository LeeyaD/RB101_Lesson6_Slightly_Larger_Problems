require 'io/console'
require 'pry'
require 'pry-byebug'

def prompt (message)
  puts "=> #{message}"
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
  players_cards = []
  dealers_cards = []
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

def initial_deal(cards, deck)
  2.times do 
    deal_card(cards, deck)
  end
end

def display_cards(players_cards, dealers_cards)
  prompt "Your cards total #{total(players_cards)}"
  prompt "Dealer\'s card is worth #{display_dealers_cards(dealers_cards)}"
end

def display_dealers_cards(cards)
  sum = 0
  value = cards[0][1]

  if value == "A"
    sum += 11 
  elsif value.to_i == 0 
    sum += 10
  else 
    sum += value.to_i
  end
end

def total(cards)
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    if value == "A"
      sum += 11
    elsif value.to_i == 0
      sum += 10
    else
      sum += value.to_i
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
    prompt "Do you want to hit or stay?(h/s)"
    answer = gets.chomp
    deal_card(players_cards, deck) if answer == 'h'
    break if answer == 's' || busted?(players_cards)
    display_cards(players_cards, dealers_cards)
    # break if answer == 's' || busted?(players_cards)
  end
  
  if busted?(players_cards)
    false
  else
    prompt "You chose to stay. Dealer's turn!"
  end
end

def dealer_turn(players_cards, dealers_cards, deck)
  loop do
    break if total(dealers_cards) >= 17 || busted?(dealers_cards)
    deal_card(dealers_cards, deck)
  end

  if busted?(dealers_cards)
    false
  else
    prompt 'Computer chose to stay!'
  end
end

def compare_cards(players_cards, dealers_cards)
  player = total(players_cards)
  dealer = total(dealers_cards)
# not accounting for player busting but being higher than dealer
  if player <= 21 && player > dealer 
    'Player'
  elsif player > 21 && player > dealer
    'Dealer'
  elsif dealer <= 21 && dealer > player
    'Dealer'
  elsif dealer > 21 && dealer > player
    'Player'
  end
end

def declare_winner(winner)
  prompt "#{winner} won!"
end

players_cards = []
dealers_cards = []
result = true

system 'clear'
prompt 'Welcome to Twenty One!' # flush out intro & explain gain

loop do
  loop do
    reset_cards(players_cards, dealers_cards)
    deck = initialize_deck
    prompt 'Dealing cards...'
    sleep(1)

    puts ""
    initial_deal(players_cards, deck)
    initial_deal(dealers_cards, deck)
    display_cards(players_cards, dealers_cards)

    puts ""
    break unless player_turn(players_cards, dealers_cards, deck)
    break unless dealer_turn(players_cards, dealers_cards, deck)
    break
  end
  puts ""
  prompt "The final score is..."
  result = compare_cards(players_cards, dealers_cards)
  display_cards(players_cards, dealers_cards)
  
  declare_winner(result)
  puts ""
  prompt 'Would you like to play again? (y/n)' # create #play_again?
  break if gets.chomp.downcase == 'n'
end

prompt 'Thank you for playing! Goodbye!'
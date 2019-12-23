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
  loop do
    answer = nil
    loop do
      prompt "Do you want to (h)it or (s)tay?"
      answer = gets.chomp
      break if ['h', 's'].include?(answer)
      prompt "Please enter a valid choice"
    end 

    if answer == 'h'  
      deal_card(players_cards, deck)
      prompt "You chose to hit!"
      display_cards(players_cards, dealers_cards)
    end
  
   break if answer == 's' || busted?(players_cards)
  end 

  if busted?(players_cards)
    # display_results(players_cards, dealers_cards)
    display_cards(players_cards, dealers_cards)
    grand_output(players_cards, dealers_cards)
    play_again?
  else
    prompt "You choose to stay. Dealer's turn!"
    line
  end
end

def dealer_turn(dealers_cards, deck)
  loop do
    break if total(dealers_cards) >= 17 || busted?(dealers_cards)
    prompt "Dealer chooses to hit!"
    deal_card(dealers_cards, deck)
  end

  if busted?(dealers_cards)
    sleep(1)
    prompt "Dealer went over!"
    # display_results(players_cards, dealers_cards)
    display_cards(players_cards, dealers_cards)
    grand_output(players_cards, dealers_cards)
    play_again?
  else
    prompt 'Dealer chooses to stay!'
  end
end

def display_final_card_totals(players_cards, dealers_cards)
  prompt "Your cards: #{players_cards} " \
  "totaling #{total(players_cards)}"
  prompt "Dealer's cards: #{dealers_cards} " \
  "totaling #{total(dealers_cards)}"
end

def display_cards(players_cards, dealers_cards)
  prompt "Your cards: #{players_cards} " \
  "totaling #{total(players_cards)}"
  prompt "Dealer's cards: #{dealers_cards[0]} and ?"
end

def detect_result(players_cards, dealers_cards) #compare_cards
  player_total = total(players_cards)
  dealer_total = total(dealers_cards)

  if player_total > 21
    :player_busted
  elsif dealer_total > 21
    :dealer_busted
  elsif dealer_total < player_total
    :player
  elsif player_total < dealer_total
    :dealer
  else 
    :tie
  end
end

def display_results(players_cards, dealers_cards)
  result = detect_result(players_cards, dealers_cards)

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

def final_totals(players_cards, dealers_cards)
  sleep(1)
  prompt "The final totals are..."
  display_final_card_totals(players_cards, dealers_cards)
  line
end

def play_again?
  puts "-------------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase == 'y'
end

def grand_output(players_cards, players_cards)
  final_totals(players_cards, dealers_cards)
  sleep(2)
  line

  display_results(players_cards, dealers_cards)
  line
end

players_cards = []
dealers_cards = []

system 'clear'
prompt 'Welcome to Twenty One!'
sleep (1)
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
  
  player_return = player_turn(players_cards, dealers_cards, deck)
  case player_return
  when true 
    next
  when false
    break
  else
    nil 
  end
  sleep(1)
  dealer_return = dealer_turn(dealers_cards, deck)
  line
  
  grand_output(players_cards, players_cards)

  break unless play_again?
end

prompt 'Thank you for playing! Goodbye!'

Twenty One Sequence
1.	Initialize deck
deck =  {
  'H' => ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'],
  'S' => ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'],
  'D' => ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'],
  'C' => ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
}
2.	Deal cards to player and dealer
#deal_cards
randomly delete a card from the deck and add it to the hand of the player/computer
store suits (keys) of deck in an array called 'suits', suits = deck.keys
randomly select a suit and store it in 'selected_suit', selected_suit = suits.sample => a key
* iniitalize 'selected_suit' = nil at the top of the method
* iniitalize 'selected_card' = nil at the top of the method
use return value to randomly select a card from the suit, selected_card = deck[suits.sample].sample
add suit & card to player/computer hand, hand << [selected_suit, selected_card]
remove card from deck, deck[selected_suit].delete(selected_card)
check if suit is empty, if it is, remove the suit too, 
if deck[selected_suit].empty?, deck.delete(selected_suit)

3.	Player turn: hit or stay

1. ask "hit" or "stay"
2. if "stay", stop asking
3. otherwise, go to #1

loop do
  puts "hit or stay?"
  answer = gets.chomp
  break if answer == 'stay'
end

a.	repeat until bust or “stay”
4.	If player bust, dealer wins.
5.	Dealer turn: hit or stay
a.	repeat until total >= 17
6.	If dealer bust, player wins.
7.	Compare cards and declare winner.

Rules
-	Normal 52 card deck with 4 suits (hearts, clubs, diamonds, spades)
and	(2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King, Ace)
Card : Value
2-10 : Face values
J/Q/K: 10
Ace	 : 1 or 11
-	Both participants are initially dealt 2 cards. The Player can see their 2 cards, but can only see one of the dealer’s cards.
-	Comparing cards: when both player and dealer stay, it’s time to compare the total value of the cards and see who has the highest value

Tips on Getting Started
1.	Figure out a data structure to contain the “deck” and the “player’s card” and “dealer’s” cards.
a.	A hash? An array? A nested array?
b.	TIP: Use a nested array where each sub-array has 2-elements that represent the cards suit and value [[‘H’, ‘2’], [‘S’, ‘J’]] = two of hearts and a jack of spades
i.	*using all strings so we don’t have to keep track of if the value is a string or integer
2.	Calculating Aces – method provided
3.	Player turn – Coded up a simple loop, use it
4.	Dealer turn – Similar pattern to ‘Player turn’ but break condition should be at the top because the dealer follows strict rules, the conditions for the dealer to stay won’t change 
5.	Displaying results - 

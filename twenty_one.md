Twenty One Sequence
2.	Deal cards to player and dealer
3.	Player turn: hit or stay
    a.	repeat until bust or “stay”
4.	If player bust, dealer wins.
5.	Dealer turn: hit or stay
    a.	repeat until total >= 17
6.	If dealer bust, player wins.
7.	Compare cards and declare winner.

-	Comparing cards: when both player and dealer stay, it’s time to compare the total value of the cards and see who has the highest value

def display_dealer_card(cards)
  face_cards = {"A" => "an Ace", "J" => "a Jack", "Q" => "a Queen", "K" => "a King"}
  suits = {"H" => "Hearts", "D" => "Diamonds", "C" => "Clubs", "S" => "Spades"}
  
  suit = cards[0][0]
  card = cards[0][1]
 

  if face_cards.keys.include?(card)
    face_cards[card]
  else
    card
  end
end


"Dealer has a #{suits[suit]} of 


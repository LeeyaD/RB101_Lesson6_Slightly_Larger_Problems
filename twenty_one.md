Make a note in notebook of:
> The use of :symbols in #detect_results & #display_results and how the two methods "talked" to each other
> Difference in break condition for #player_turn from 'break if answer.downcase == 's' to 'break if ['h', 's'].include?(answer)'
> How 3 game exits were incorporated (look at the number of loops and breaks needed to completely exit game) 

Change code:
> Remove 'requires' at the top of page
> Don't add intro for game

Some bonus features to consider:

1. Calculating the total. Every time we need the player's or dealer's total value, we call a total method. Doing this is expensive, from a performance perspective (suppose that we cared about performance). Do we really need to calculate the total value over and over? Can we use a local variable to cache the calculation, and instead of calling total every time, just use the local variable? 

We're unnecessarily calling total multiple times here. We can cache each player's total in a local variable within the main loop and just call those local variables instead, like this:

player_total = total(player_cards)
dealer_total = total(dealer_cards)
Now we can replace each call to total with the appropriate local variable. This includes changing the busted? and detect_result methods to accept these new local variables instead of player_cards or dealer_cards.

If we cache each player's total like this, will it continue to update correctly throughout the game? If not, at what point do we need to update each player's total?
------------------
2. We use the play_again? three times: after the player busts, after the dealer busts, or after both participants stay and compare cards. Why is the last call to play_again? a little different from the previous two?

3. Ending the round. As mentioned above, there are 3 places where the round can end and we call play_again? each time. But another improvement we'd like to make is to give it a consistent end-of-round output. Right now, we get a grand output only after comparing cards. Can we extract this to a method and use it in the other two end-of-round areas?

4. Keep track of who won each round, and declare whoever reaches 5 points first as the winner.

5. What if we wanted to change this game to Thirty-One, and the dealer hits until 27? Or what if our game should be Forty-One? Or Fifty-One? In other words, the two major values right now -- 21 and 17 -- are quite arbitrary. We can store them as constants and refer to the constants throughout the program. If we wanted to change the game to Whatever-One, it's just a matter of updating those constants.

KEY DIFFERENCES IN SOLUTION CODE VS MINE
3. Used the result of one method (#detect_result) as keys for another (#display_result)
4. Display the scores when user/dealer has stayed
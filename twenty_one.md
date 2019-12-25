Make a note in notebook of:
> The use of :symbols in #detect_results & #display_results and how the two methods "talked" to each other
> Difference in break condition for #player_turn from 'break if answer.downcase == 's' to 'break if ['h', 's'].include?(answer)'
> How 3 game exits were incorporated (look at the number of loops and breaks needed to completely exit game) 
> Arbitrary code (WHATEVER_ONE, DEALER_HITS_UNTIL) should be made into constants, this way if we choose to change them we only have to go to one place!
> calling a method repeatedly, like we did #total(cards) is expensive performance-wise. Better off using a local variable to cache the calculation rather than call it every single time

Change code:
> Remove 'requires' at the top of page
------------------


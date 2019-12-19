Hi Leeya, I will be reviewing your code today.

Gameplay
Well done on implementing this game! The game flows well, the display looks good and the input validation is strong. Some minor suggestions for improvement:

Instead of relying on the sleep method and guessing how long it will take the user to read something, you could let the user hit any key to continue. There are a few ways to do this, probably the simplest is to add require 'io/console' to the top of your file. This will give you access to more methods for interacting with the console. You can then use STDIN.getch in your code and the program execution will wait until the user hit a key.
The input validation for the 'play again?' question could be improved. As it is, any word starting with 'y' will count as yes, anything else as a no.

Rubocop
No offenses, but I see you disabled some cops for two methods. For the display_board method, it's to be expected as it's also what we do in the proposed solution. That method is also quite straightforward. For the computer_places_piece! method, though, I think it would benefit from refactoring in order to simplify the logic. I will have some suggestions below.

Source Code
Overall your code is clear and well-written. I like that you extracted a lot of logic to methods and you mostly succeeded at keeping those methods short and focused. Consequently, your main game loop is relatively short and easy to understand.

Logic
There are other 'chunks' of logic that could be moved out of the main game loop in order to declutter it. For example, the display of the round winner (lines 215-219) or the 'play again?' question (lines 232-234). Even the loop on lines 206-210 could possibly be extracted to a play_round (or sim.) method.
The computer_places_piece! method is doing too much. I would create separate methods for the different pieces of logic: an offensive move, a defensive move, and a center square method. These methods could return either a square number or nil. With that in place, you can use the || operator and its short-circuiting behavior in the following way:
square = offensive_move(brd) || defensive_move(brd) || center_square(brd) || empty_squares(brd).sample 
If a given value is nil Ruby will evaluate the next one, and so on until it reaches a truthy value. This would really improve the readability of the computer_places_piece! method.

Readability
While constants are usually defined at the top of the file, local variables should be initialized close to the code that uses them. I would move scoreboard closer to the main game loop.
It's usually better to avoid abbreviations for variable names (e.g. scrbrd). It saves a few characters, but it negatively impact readability - not worth it in my opinion. See here for some guidelines.
It would be better to use a constant to store the max number of wins (5). It makes your intent more explicit and it allows you to make changes easily in the future (a real-world concern!): you only need to change the value in one place, where the constant was defined, instead of going through your code and changing it everywhere you used it.
In the who_moves_first method, you don't need the ternary at the end. Simply using result == 'Player' will return the proper boolean. Something similar could be done in your players_choice method instead of the case statement.
Final Thoughts
Excellent work, Leeya! Most of my comments concern relatively minor issues, though I would recommend refactoring your code taking into account some of my suggestions: there is a lot to be learned by the refactoring process. The most important would be to refactor the computer_places_piece! method to get rid of the Rubocop offenses.

Let me know if you have any further questions.


# GAMEPLAY
#  [ ] using STDIN.getch instead of #sleep
#  [ ] improving #play_again?, anyword starting w/ 'y' will do


# RUBOCOP
#  [ ] Refactor #computer_places_piece! to avoid disabling cops

# SOURCE CODE
# - Logic
#  - chunks of code to move out of main loop and extract into methods: 
#    1. Lines 215-219, display of round winner  
#    2. Lines 232-234, the 'play_again?' question
#    3. Loop on lines 206-210, could be extracted to #play_round method
#  - #computer_places_piece! could be extracted into numerous methods that return either a # nil
# **square = offensive_move(brd) || defensive_move(brd) || center_square(brd) || empty_squares(brd).sample 
# - Readability
#  - bring variable 'scoreboard' down closer to the main game loop, closer to the code that uses it
#  - avoid abbreviations for variable names
#  - store the max number of wins, 5, in a constant. Makes intent explicit & easier to change in the future
#  - don't need the ternary in 'result == 'Player' ? true : false', 'result == 'Player' alone will return 
#    either true or false
 

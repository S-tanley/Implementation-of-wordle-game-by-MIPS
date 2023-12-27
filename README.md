# Implementation-of-wordle-game-by-MIPS
This is a midterm project for CS 0447. I just use Mars implement a small, simple wordle game.

The only thing not work very properly is that when some letters appear many time. For example if the word in the system is 'apple', and the user guess 'ppppp', we should response like p[p][p]pp, however we get (p)[p][p](p)(p). It is really hard to solve this issue in assemble language since this is too complex. I note that in the example, this issue also remian. So, you know. 
Also, I only store 100+ words in the data(array name is 'words'), and many of them are abnormal, so to some extent, it is not a good game.
Except these, there are no technicial issues in my code.

The first part is the main part, first generate a random number, then use this number to deicde the position of the first word I will choose. 
Then jump into core_loop, this is the game body, since the whole game in fact is a loop.
In the core_loop, the first is print hello_page, I use the function hello_page.
Then is the play_decide, this part is let player decide if he want to continue to play or not.
If the player decide to play it comes to guess_loop. This will let player guess five times. At anytime, if the player get the right answer, then this will to the start of the core_loop and congratulate the player. If after 5 times the player still guess wrong, then it will also jump to the start of the core_jump, and print the fail information. 
The impletaion detail you can see the comments in the source codes.

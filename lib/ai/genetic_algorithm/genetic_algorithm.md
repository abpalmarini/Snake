# Genetic Algorithm (Attempt)
This is an attempt at building a genetic algorithm with no libraries to help me try
understand and learn the fundamentals of AI. I read a couple articles on neural networks
to help me attempt this, but please note I have not taken any courses on AI or done a
lot of research into learning it yet. This project is the start of my AI journey and was
only built to act as a playground for experimenting in. Thus, a lot of code is messy and
I'm sure there are numerous things wrong with my implementation. 

## Approach 
As I have no training data to train the neural network, I instead use what's called a
genetic algorithm. I create 100 networks all with random weights and then let each
network play one after the other. I give a score (fitness function) to each snake based
on how well it does. It gets 1 point for each move it stays alive, 10 points for eating
an apple and it loses 1 point for every move it takes away from the apple's position.
Once each snake in the initial generation has played, I take the two snakes with the
highest scores and combine their weights into one new set of weights. I then create 100
new snakes based off this 'baby' set of weights, where a random selection of weights are
modified for each snake (mutations). This process is then continually repeated.

Each snake was being fed the following binary (1 or 0) inputs for each new grid:
* Is it empty one grid to the:
  * left                   - a
  * right                  - b
  * top                    - c
  * bottom                 - d
* Is the apple to the:
  * left                   - e
  * right                  - f
  * top                    - g
  * bottom                 - h

    Input - [a,b,c,d,e,f,g,h] 

And based off those inputs it will decide a direction to take (with one hidden layer):
* Left
* Right
* Up
* Down

I found that it works well for the first few generations and I even get snakes eating 
multiple apples in a row, but then it almost always ends up with an entire generation
only choosing to move up. I could be wrong, but I'm guessing this has something to do 
with the fact that when the snake first spawns it is moving upwards.

Nevertheless I had a lot of fun making and experimenting with this, and look forward to
now learning as much as I can about AI.

<img src="https://github.com/abpalmarini/snake_ai/blob/master/screenshots/ga_playing.png" width="400">

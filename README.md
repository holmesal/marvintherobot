Marvin the Robot
================

Based on an example from the excellent introduction to complexity science "Complexity: A Guided Tour"

Marvin is a fictitious robot dropped in the corner of a grid. There are random bits of trash scattered throughout the grid - his sole purpose in life is to collect them all. He seems to enjoy it. Trash disposal is beyond the scope of this project.

Setup
-----------
The area is divided up into a grid. Each location on the grid contains a value corresponding to what it contains. The possibilities are:
* Nothing (0)
* A piece of trash (1)
* A wall (2)

Marvin can only see what is underneath him, and directly to his North, South, East, and West (no diagonals)


Genome
-----------

For every situation marvin finds himself in, there is a corresponding strategy that tells him what to do in that situation. For example, if there is nothing to his North, South, East, and current location but a piece of trash to his west, he has a corresponding rule that tells him what to do. This situation would be encoded as '00010' ([North, South, East, West, Current] using the values described above).

If you take '00010' and convert it to an integer as a base-3 string (because we had 0,1,2 for possible values), you get the integer 3. This tells marvin to do whatever is the 4th gene (0-indexed) in his genome tells him to do. Marvin's genome is 243 genes long, because that is the number of unique situations he can find himself in (3^5, where '222222' corresponds to gene 243).

Marvin's genome looks like '12343212312432213123' ... to 243 integers. Each integer corresponds to an action - for example, 0 is "Move North", 4 is "Do Nothing", etc.

This genome is the thing that actually evolves.

Fitness
-----------

Marvin is rewarded 10 points for successfully picking up a piece of trash, fined 5 points for attempting to move into a wall, and fined 1 point for attempting to pick up a piece of trash when there is none in his current location. Marvin also has a 200-move limit for each simulation.

The fitness of the instance of Marvin (the strategy) is simply the number of points that he has at the end of a simulation. If he spends all 200 of his moves repeatedly running into a wall (which happens quite a bit in the early generations), he will end that simulation with a fitness score of -1000 (200 moves * -5 points for each wall hit).

Evolution
------------

Each genome is run 100 times, with a random assortment of trash each time. The genome's fitness is the average of the fitness from each run.

After all genomes have been tested, parents are randomly selected from the population, with a probability proportionate to their fitness scores.

Once two parents have been selected, and random number between 0 and 243 decides where to "slice" the genome. Two children are created, where the genome of a single child contains the genome of the first parent up to the splice point, and the genome of the second parent past that point. Once the carrying capacity of the population (constant 200) is reached, no more children are created.

Mutation
------------

Every time a child is created, there is a small chance that any gene in it's genome will flip to a random (allowed) value. You know, variety is the spice of life and all that.


Winning
---------

There is a 50% chance that any given location will contain trash. For the 100 squares, that translates to roughly 50 that are occupied by trash. If Marvin is able to pick up all of the trash successfully, the theoretical maximum score is 500. In reality, this varies a small amount as the number of locations containing trash is not exactly 50% of the total.


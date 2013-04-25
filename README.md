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

For every situation marvin finds himself in, there is a corresponding strategy that tells him what to do in that situation. For example, if there is a piece of trash to his North and nothing else to his East, West, South, and current location, the grid looks like:
000
000
000
he has a corresponding rule that tells him what to do. This situation would be encoded as '10000' (North, South, East, West, Current where) 

The component that evolves is Marvin's "genome", the collection of his actions in response to finding himself in specific situations. For example, if he finds himself in empty space, with no walls or trash around him, one of his genes tells his what to do (move in a certain direction, try to pick up some trash, etc).

Fitness
-----------

Marvin is rewarded 10 points for successfully picking up a piece of trash, fined 5 points for attempting to move into a wall, and fined 1 point for attempting to pick up a piece of trash when there is none in his current location. Marvin also has a 200-move limit for each simulation.

The fitness of the instance of Marvin (the strategy) is simply the number of points that he has at the end of a simulation. If he spends all 200 of his moves repeatedly running into a wall (which happens quite a bit in the early generations), he will end that simulation with a fitness score of -1000 (200 moves * -5 points for each wall hit).

Winning
---------

There is a 50% chance that any given location will contain trash. For the 100 squares, that translates to roughly 50 that are occupied by trash. If Marvin is able to pick up all of the trash successfully, the theoretical maximum score is 500. In reality, this varies a small amount as the number of locations containing trash is not exactly 50% of the total.

Marvin the trash-collecting robot
=================================

But why?
---------------------------------

This excellent example is taken from a book called *Complexity: A Guided Tour*. 
If you're new to genetic algorithms, this is supposed to be an easy-to-follow example.

Wokka wokka. Or something.

Variables
---------

The maximum number of members in the population.

	carryingCapacity = 200

The number of iterations to go through. I don't mess around with measuring convergence in this example.

	numIterations = 1

The number of situations over which to average a single solution's fitness	
	
	fitnessIterations = 100

The side length of the area to be cleaned

	sideLength = 10

The limit on the number of moves Marvin can make per simulation

	moveLimit = 200

Setup
--------

	rando = (min,max) ->
		max += 1
		Math.floor Math.random() * (max - min) + min

	displayGrid = (grid) ->
		display = []
		for x in [0..grid.length-1] 
			display[x] = []
			for y in [0..grid.length-1]
				display[x][y] = grid[y][x]

		console.log display

The solution class is one potential candidate solution. Each solution has a genome.


	class Solution
		constructor: ->
			@fitnessvals = []
			@fitness = 0
			@genome = []
			@simvals =
				x: 0
				y: 0
				move: 0
		randomGenome: ->
			@genome = (rando 0,6 for x in [0..242])

The position in the genome describes what situation Marvin finds himself in. There are 243 possible situation, some of which are impossible.

Each element in the genome describes Marvin's course of action when faced with that situation. They are:

* 0 Move North
* 1 Move South
* 2 Move East 
* 3 Move West
* 4 Stay Put 
* 5 Pick Up A Can 
* 6 Make a Random Move

Damn.
		
		findFitness: ->
			for x in [0..fitnessIterations-1]
				@fitnessvals[x] = @runSim()
			sum = 0
			for fitval in @fitnessvals
				sum += fitval
			@fitness = sum/@fitnessvals.length
console.log @fitness

		runSim: ->
			grid = randomGrid()
			@simvals = 
				x: 0
				y: 0
				move: 0
				grid: grid
				points: 0

			while @simvals.move < moveLimit

console.log "------------------"+@simvals.move

Look at the surrounding squares, turn them into strings, and convert that string to a base-3 integer - the index of the genome to use for this situation
				
				situation = @getSituation()
				index = parseInt(situation,'3')
				choice = @genome[index]

				switch choice
					when 0
						@moveNorth()
						
					when 1
						@moveSouth()
					when 2
						@moveEast()
					when 3
						@moveWest()
					when 5
						@pickUpCan()
					when 6
						@randomMove()



				@simvals.move += 1
console.log "Points: " + @simvals.points

			@simvals.points

Looking around
-------------

Build a string corresponding to the current situation (North, South, East, West, Current where 0=empty, 1=can, 2=wall)

		getSituation: ->
console.log "Current x: " + @simvals.x
console.log "Current y: " + @simvals.y

			if @simvals.y == 0
				north = '2'
			else
				north = String @simvals.grid[@simvals.x][@simvals.y-1]

			if @simvals.y == sideLength-1
				south = '2'
			else
				south = String @simvals.grid[@simvals.x][@simvals.y+1]

			if @simvals.x == 0
				west = '2'
			else
				west = String @simvals.grid[@simvals.x-1][@simvals.y]

			if @simvals.x == sideLength-1
				east = '2'
			else
				east = String @simvals.grid[@simvals.x+1][@simvals.y]

			current = String @simvals.grid[@simvals.x][@simvals.y]
				

displayGrid(@simvals.grid)

console.log "North: " + north
console.log "South: " + south
console.log "East: " + east
console.log "West: " + west
console.log "Current: " + current

Concatenate to a single base-3 string. This will be converted to an integer that maps to a location in the solution's genome.

			north+south+east+west+current


Going places
------------

		moveNorth: ->
			if @simvals.y == 0
				@simvals.points -= 5
			else
				@simvals.y -= 1

		moveSouth: ->
			if @simvals.y == sideLength-1
				@simvals.points -= 5
			else
				@simvals.y += 1

		moveEast: ->
			if @simvals.x == sideLength-1
				@simvals.points -= 5
			else
				@simvals.x += 1

		moveWest: ->
			if @simvals.x == 0
				@simvals.points -= 5
			else
				@simvals.x -= 1

		pickUpCan: ->
			if @simvals.grid[@simvals.x][@simvals.y] == 1
				@simvals.points += 10
				@simvals.grid[@simvals.x][@simvals.y] = 0
			else
				@simvals.points -= 1

		randomMove: ->
			randint = rando(0,3)
			switch randint
				when 0
					@moveNorth()
				when 1
					@moveSouth()
				when 2
					@moveEast()
				when 3
					@moveWest()

	
	randomGrid = () ->

Build the grid and generate random cans. 0 is an empty location, 1 contains a can, and 2 is a wall

		grid = []
		for x in [0..sideLength-1]
			grid[x] = []
			for y in [0..sideLength-1]
				grid[x][y] = rando 0,1

Comparator function to sort the array of objects by the $avgfitness value of each object

	compare = (a,b) ->
		if a.fitness > b.fitness
			return -1
		if a.fitness < b.fitness
			return 1
		return 0

Kicking things off 
------------------

	initialize = () ->

Generate a bunch of initial candidate solutions
		
		solutions = []
		for x in [0..carryingCapacity-1]
			s = new Solution
			s.randomGenome()
			solutions[x] = s

		i=0
		while i < numIterations
			console.log "%%%%%%%%%%%%%%% " + i + " %%%%%%%%%%%%%%%"
			for s in solutions
				s.findFitness()
			i+=1

		solutions.sort(compare);

Calculate the total, in order to normalize. This total is based on the distance between the best solutions and the worst solutions

		total = 0
		for s in solutions
			s.dfitness = s.fitness - solutions[solutions.length-1].fitness
			total += s.dfitness
		console.log total

		for s in solutions
			s.fracfitness = s.dfitness/total
			console.log s.fracfitness

	initialize()
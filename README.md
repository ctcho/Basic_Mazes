Author: Cameron Cho

Synopsis: This is my implementation of PA Mazes. It takes some user input, creates a maze and solves it.
Note: I am aware of the redundancy and limitedness of this code. When I have more time, I will make it better. But for the purposes of this assignment, I must turn in what I have.

 Breakdown: This code is divided into 4 major files:
 1. maze_shell.rb: The code the user runs to start the program.
 2. maze_parser.rb: Takes in the user's input and handles displaying text.
 3. helper.rb: Aids maze_parser.rb with overly repetitive tasks.
 4. maze_driver.rb: The 'brain' of the program, it includes generating the maze, displaying it and finding paths through it given sets of coordinates.

 Details - Methods
 1. maze_shell.rb
  - A very basic program that just draws the user into the rest of the program.

 2. maze_parser.rb
  a. intro
   - Asks the user if they want to play the maze. The user answers yes or no, and answering yes will engage the rest of the program by calling "generate_maze", while answering no will end the program.

  b. generate_maze
   - Asks the user for the number of rows and columns they want in the maze. It calls the "get_valid_numbers_only" method from its helper object to make sure that the user passed in a valid, reasonable (<2000) number for each input.
   - It then gets the MazeDriver object to create a new maze and display it (using .create and .display, respectively).
   * Admission: I did not have enough time to create a randomizer that generates random, valid mazes. I have provided a single maze that allows for complete testing of this process.
   * Sadly, this means that the only way to get this iteration of the program to run is by providing 5 rows
   and 5 columns.
   - It moves onto the final part of this program by calling "work_with_maze(x, y)".

  c. work_with_maze(x, y)
   - Having displayed the maze, it gives the user four options:
    + print out the maze again ('print')
    + get the driver to check if you can solve the maze with a given set of coordinates ('solvable?')
    + get the driver to solve the maze with a given set of coordinates ('solve')
    + finish with the maze ('done')
   - If the user chooses 'solvable?' or 'solve', it asks the user for two sets of coordinates, a start coordinate and end coordinate (again getting validated with "get_valid_numbers_only"), and then gets the driver to run its solving algorithm.

  3. helper.rb
   a. get_valid_numbers_only
    - Checks the user input for a valid number, and for coordinates within a maze, a number within the bounds of the maze. If the user does not comply, they will not be able to move out of this method.

   b. get_coordinates
    - Asks the user for a set of start coordinates and a set of end coordinates, using "get_valid_numbers_only".

  4. maze_driver.rb
   ~ It first creates a binary representation of the maze via a 2D array, with 0 = space and 1 = wall. It has (R*2+1) rows and (C*2+1) columns in order to represent an R x C maze.

   a. create(input)
    - If the length of the input string does not match the dimensions of the maze, stop right there.
    - Otherwise, start filling in the 2D array. Go by row, then by column.

   b. display(position=nil)
    - Very similar to create(input), except it translates the 0's and 1's of the binary representation to a more familiar-looking maze of walls and spaces. It even displays where the user goes in a maze.

   c. solve(coord_array, write)
    - The coord_array serves as a means of reducing the number of parameters that are passed into the method.
     coord_array[0] = starting X coordinate
     coord_array[1] = starting Y coordinate
     coord_array[2] = ending X coordinate
     coord_array[3] = ending Y coordinate
    - write is whether the user wanted to have a printed solution or not ('solvable?' vs. 'solve')
    - It creates a "log" which generates an R x C array in order to keep track of where the user has been in the maze.
    - It then calls the real method that solves the maze, maze_crawler(coord_array, write, log). It will tell the user whether it was able to solve the maze given the coordinates.

   d. maze_crawler(coord_array, write, log)
    - This method implements a depth-first-search. In this implementation, coord_array[0] is now the current X coordinate, and coord_array[1] is now the current Y coordinate.
    - If the current coordinates are equal to the ending coordinates, finish.
    - Otherwise, check if the user can travel north, south, east or west. Checking each direction requires checking each of the following, which is checked in order:
     + If moving in that direction is still within the maze bounds
     + If there is no wall in your way in moving that direction
     + If the log says that you haven't been where you're going
    - For every direction you can go in, go in it and repeat maze_crawler(coord_array, write, log). This is equivalent to investigating any route you can take as far as you can.
    - If there are no directions you can go in, stop. This is equivalent to backtracking.
    - There is a logger method that writes down the user's progress if write = true.
    * Admission: I know this is redundant, but I did not have enough time to develop a new algorithm based on the logger method; I would create a method similar to logger if I had the time to refactor it.

   e. logger(write, current_coords, adder, direction=nil)
    - This method will write down that the user travels from (X, Y) to some other coordinate in a general sense--but only if the user wanted to have the solution written down for them. If direction=nil, then you went into a dead end.

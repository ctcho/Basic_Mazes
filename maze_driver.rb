require 'byebug'
# the main method, or the brain of this program. It initializes, stores, displays and even solves mazes given to it.

class MazeDriver
  def initialize(x, y)
    #Something I noticed: every cell of a maze looks like this:
    #    012
    #0   +-+
    #1   | |
    #2   +-+
    # This means that every row and column is a 3x3 format, and a 4x4 maze is actually a 9x9 grid of 0's and 1's.
    # For instance, a 2x2 maze is a 5x5 grid of 0's and 1's. This pattern suggests that an RxC maze is comprised
    # of an (R*2 + 1)x(C*2 + 1) grid of 0's and 1's.
    #It's actually harder to code it this way... but it's more intuitive in the long run.
    init = 0
    @rows = (2*x.to_i) + 1 #Goes from left to right
    @columns = (2*y.to_i) + 1 #Goes from top to bottom
    @maze_map = Array.new(@rows) #Create our representation of a map!
    while init < @maze_map.length
      @maze_map[init] = Array.new(@columns, "0") #Doing it the "fast" way links the Arrays as a single object shared amidst the values in the main Array;
      #Ask me about that if you don't get what that means
      init += 1
    end
  end

  # Passes in a string of 0's and 1's, and loads that to the map.
  # Rules for mazes:
  # 1. It cannot be all walls
  # 2. There can only be n + 1 walls for n cells in a row.
  #  a. This means that every other space MUST be a 0.
  # 3. There are 4 walls for the perimeter of the maze, always.
  #  a. This means that the entire first row must
  # This method in particular fills up @maze_map with the values of the string.
  def create(input)
    # Error checking. Mazes are rows x columns.
    if input.length != @columns*@rows
      puts "The input does not match the dimensions of the array."
    else # Fill up the map. It goes from left to right, then down.
      index = 0
      row = 0
      column = 0
      while index < input.length
        #Left to right...
        @maze_map[row][column] = input[index]
        index += 1
        row += 1
        #Then go down one.
        if row > @maze_map.length - 1
          column += 1
          row = 0
          #Repeat.
        end
      end
    end
  end

  #Another iterator.
  # Something to keep in note: this is how you should view a maze in this program:
  #@    @rows ----+
  #c  [|"1"| |"1"| |"1"|]
  #o   |"0"| |"0"| |"1"|
  #l   |"1"| |"1"| |"0"|
  # How it's actually stored:
  # [["1","0","1"],["1","0","1"],["1","1","0"]]
  # Essentially, to view the maze properly, you need to rotate the stored interpretation 90 degrees clockwise.
  # Note the special case of position; when the user is having the program show the solution, it traces where it is in the maze.
  def display(position=nil)
    r = 0 #rows
    c = 0 #columns
    while c < @columns
      if r%2 == 0 && c % 2 == 0 #Mainly accounts for corners
        print "+ "
      elsif r%2 == 0 && c % 2 != 0 && @maze_map[r][c] == "1" #Could be a wall
        print "| "
      elsif r%2 != 0 && c % 2 == 0 && @maze_map[r][c] == "1" #Could be a wall
        print "- "
      elsif position != nil && position[0] == r && position[1] == c #This is where you are in the maze.
        print "X "
      else
        print "  " #Cells and open pathways need spaces.
      end
      r += 1
      if r > @rows - 1 #Again, print one row at a time.
        c += 1
        r = 0
        print "\n"
      end
    end
  end

  # Given the starting coordinates, this method calls a a recursive method to attempt to solve the maze.
  # write checks if the user wants to print out the solutions
  # log keeps track of where the maze crawler has been and if the desired path through the maze can be obtained.
  def solve(coord_array, write)
    # The reason I'm creating this here is because we need a fresh log every time we want to solve the maze.
    # It's also more intuitively formed this way, going off the number of cells vs. the 0's and 1's comprising the maze.
    log = Array.new((@rows-1)/2)
    i = 0
    while i < ((@columns-1)/2)
      log[i] = Array.new((@columns-1)/2, false)
      i += 1
    end
    maze_crawler(coord_array, write, log)
    if log[coord_array[2]][coord_array[3]] && !write #The user only wanted to know if the maze was solvable.
      puts "This maze can be solved. If you want to see the solution, use the command 'solve'."
    elsif log[coord_array[2]][coord_array[3]] && write # The user wanted a solution.
      puts "And that's the solution!"
    else #No solution could be found.
      puts "Sorry about that, seems that the maze doesn't have a solution for you..."
    end
    print "\n"
  end

  # Helpful example for coordinate translation:
  # If curX = 1 and curY = 1,
  # That is @maze_map[3][3].
  # In general, where you are in the maze is @maze_map[(2*curX) + 1][(2*curY) + 1]
  # However, you also need to check for walls when you move, which is why I have indX/indY + 1.
  # You also need to check if you're still going to be in bounds when making a move.
  # Another helpful note: The top-right corner of the maze is (0, 0).
  # If you pay close attention, this is, in essence, an implementation of Depth First Search.
  # However, given the recursion in this method, the maze displays that show progression through it
  # Are out of order. Don't know how to fix that... sorry.
  def maze_crawler(coord_array, write, log)
    indX = (2*coord_array[0])+1
    indY = (2*coord_array[1])+1
    i = 0
    counter = 0 # this exists to see if any of the if statements were tried.
    # Its main purpose is to see if the algorithm had anywhere else to go.
    if coord_array[0] == coord_array[2] && coord_array[1] == coord_array[3] # Have you managed to reach your destination?
      log[coord_array[0]][coord_array[1]] = true #Always need to mark where you've been...
      counter += 1
      return true
    end
    #I know it's redundant, but this is the nature of maze crawling.
    # In order: checks if you're in bounds, you're not hitting a wall going this direction and that you haven't been where you're going to.
    if indX + 2 < @rows-1 && @maze_map[indX + 1][indY] != "1" && !log[coord_array[0]+1][coord_array[1]]  #can you go east?
      log[coord_array[0]][coord_array[1]] = true #Keep track of where you've been.
      coord_array[0] += 1
      logger(write, coord_array[0..1], 1, 'x') #If the user wanted to see the solution.
      maze_crawler(coord_array, write, log)
      counter += 1
    end
    if indX - 2 > 0 && @maze_map[indX - 1][indY] != "1" && !log[coord_array[0]-1][coord_array[1]] #can you go west?
      log[coord_array[0]][coord_array[1]] = true
      coord_array[0] -= 1
      logger(write, coord_array[0..1], -1, 'x')
      maze_crawler(coord_array, write, log)
      counter += 1
    end
    if indY - 2 > 0 && @maze_map[indX][indY - 1] != "1" && !log[coord_array[0]][coord_array[1]-1] #can you go north?
      log[coord_array[0]][coord_array[1]] = true
      coord_array[1] -= 1
      logger(write, coord_array[0..1], -1, 'y')
      maze_crawler(coord_array, write, log)
      counter += 1
    end
    if indY + 2 < @columns-1 && @maze_map[indX][indY + 1] != "1" && !log[coord_array[0]][coord_array[1]+1] #can you go south?
      log[coord_array[0]][coord_array[1]] = true
      coord_array[1] += 1
      logger(write, coord_array[0..1], 1, 'y')
      maze_crawler(coord_array, write, log)
      counter += 1
    end
    if counter == 0 #You're stuck. This direction is a dead end, and you need to backtrack, if possible.
      log[coord_array[0]][coord_array[1]] = true
      logger(write, coord_array[0..1], 0)
      return false
    end
    #No matter what happens, the log will always track that the current position has been visited.
  end

  #Convenience method that exists to trace the solver as it runs through the maze.
  # It makes it cleaner to read, certainly.
  def logger(write, current_coords, adder, direction=nil)
    if write
      if direction == 'x'
        puts "Travelling to (#{current_coords[0]+adder}, #{current_coords[1]}) from (#{current_coords[0]}, #{current_coords[1]})."
        display([(2*(current_coords[0]+adder))+1, (2*(current_coords[1]))+1])
      elsif direction == 'y' #It moves in the y direction
        puts "Travelling to (#{current_coords[0]}, #{current_coords[1]+adder}) from (#{current_coords[0]}, #{current_coords[1]})."
        display([(2*(current_coords[0]))+1, (2*(current_coords[0]+adder))+1])
      else #You hit a dead end.
        puts "Uh-oh. Ran into a dead end... Backtracking..."
      end
      print "\n"
    end
  end
end

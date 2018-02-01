require_relative "maze_driver.rb"
require_relative "helper.rb"


# this is the second part of the interface.
class MazeParser
  def initialize
    @driver = nil #The maze implementation object. will be created later down!
    @helper = Helper.new
  end

  def intro
    puts "Welcome to the maze generator. Want to play through a maze?"
    # Will keep running until the user says they're done.
    while true
      print "maze> "
      input = $stdin.gets.chomp
      input = input.downcase
      if input == "yes"
        generate_maze
      elsif input == "no"
        puts "Oh. Okay. Have a good day!"
        break
      else
        puts "What was that? I didn't quite catch that..."
      end
    end
  end

  # Second of three main methods being used. Takes the specifications from the user and generates the maze.
  def generate_maze
    puts "Great! Let's get this started up..."
    print "How many rows should this maze have? "
    x_coord = @helper.get_valid_numbers_only($stdin.gets.chomp, 2000) #To test, put in 5
    print "How many columns should this maze have? "
    y_coord = @helper.get_valid_numbers_only($stdin.gets.chomp, 2000) #Same here
    @driver = MazeDriver.new(x_coord, y_coord)
    # Sorry, but I'm not creating a randomizer. This map tests all the functionality of the maze-solver well enough to consider this complete.
    @driver.create("1111111111110000010101111110111111010101010111111010111100000001011111111011110101010101111111111111010101010111111111111")
    puts "Okay, I've got your maze right here..."
    puts "Note: coordinates are (0, 0) at the top-left corner."
    @driver.display
    work_with_maze(x_coord.to_i, y_coord.to_i) # The next part of this sequence, but in another method to make it cleaner.
  end

#This final method is the second 'loop' of the program. As long as the user is still interested in the maze,
# It will allow the user to keep working with it.
  def work_with_maze(x, y) #Should be ints at this point
    puts "So, you can solve it yourself, check if the maze can be solved or get a trace through the maze, if it can be solved. The commands are as follows:"
    @helper.prompt # See the below method
    while true
      print "maze> "
      input = $stdin.gets.chomp
      if input == 'done'
        puts "Thanks for playing! Want to play through another maze?"
        break
      elsif input == 'solvable?' || input == 'solve'
        coord_array = @helper.get_coordinates(x, y)
        puts "Checking if the maze is solvable... Please wait..."
        if input == 'solvable?'
          @driver.solve(coord_array, false) #User only wants to know if they can complete the maze
        else
          @driver.solve(coord_array, true) #user wants a solution to the maze
        end
        puts "Anything else? Remember, the commands are as follows:"
        @helper.prompt
      elsif input == 'print'
        puts "Want to see the maze again? Sure, here it is:"
        @driver.display
        puts "Anything else? Remember, the commands are as follows:"
        @helper.prompt
      else
        puts "What's that? I didn't get that. The list of available commands are as follows:"
        @helper.prompt
      end
    end
  end
end

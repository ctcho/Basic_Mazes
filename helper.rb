class Helper
  def initialize
  end
  # Helper method for generate_maze and maze_solver. As long as the user does not provide a valid input,
  # Whether that be because the value is not a number or not within the specified bound,
  # keep bugging them until they do.
  def get_valid_numbers_only(coord, bound)
    while !coord.match(/[0-9]+/) || coord.to_i >= bound || coord.to_i < 0 #looks for digits only
      if !coord.match(/[0-9]+/)
        print "That's not a number. Please put in a number: "
        coord = $stdin.gets.chomp
      else
        print "You provided an out-of-bounds coordinate. Please try again: "
        coord = $stdin.gets.chomp
      end
    end
    coord
  end

  #This shows up often enough to just put this in its own method. Just gives the user their options.
  def prompt
    puts "'done': finish with this maze"
    puts "'solvable?': check if this maze can be solved"
    puts "'solve': get a route through the maze, if it can be solved"
    puts "'print': get a display of the maze again"
  end

  # Put here to make the maze_parser cleaner. It returns an array of coordinates.
  def get_coordinates(x, y)
    puts "Where do you want to start in the maze?"
    print "What X-coordinate? "
    start_x = get_valid_numbers_only($stdin.gets.chomp, x)
    print "What Y-coordinate? "
    start_y = get_valid_numbers_only($stdin.gets.chomp, y)
    puts "Where do you want to finish?"
    print "What X-coordinate? "
    end_x = get_valid_numbers_only($stdin.gets.chomp, x)
    print "What Y-coordinate? "
    end_y = get_valid_numbers_only($stdin.gets.chomp, y)
    [start_x.to_i, start_y.to_i, end_x.to_i, end_y.to_i]
  end
end

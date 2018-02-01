require_relative "maze_parser.rb"

# This is just the interface, and the class that starts everything up. It asks the user if they want to go through a maze.
# It only accepts yes or no answers at this stage.
parser = MazeParser.new
parser.intro

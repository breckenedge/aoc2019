require './intcode_computer.rb'

class IntcodeRobot
  DIRECTIONS = [
    [0, -1], # up
    [1,  0], # left
    [0,  1], # down
    [-1, 0]  # right
  ]

  attr_reader :painted, :whites, :position

  def initialize(input, whites: [])
    @computer = IntcodeComputer.new
    @computer.load(input)
    @position = [0, 0]
    @direction = 0
    @painted = []
    @whites = whites
  end

  def execute
    while !@computer.finished? do
      @computer.stdin << (@whites.include?(@position) ? 1 : 0)
      @computer.execute

      color, turn = @computer.stdout.shift(2)

      if color == 1
        @whites << @position.clone
      else
        @whites.reject! { |w| w == @position }
      end

      @direction = (@direction + (turn == 0 ? -1 : 1)) % 4
      
      @position[0] += DIRECTIONS[@direction][0]
      @position[1] += DIRECTIONS[@direction][1]

      @painted << @position.clone unless @painted.include?(@position)
    end
  end
end

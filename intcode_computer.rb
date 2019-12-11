# Intcode program first used in Advent of Code - Day 2

require 'colorize'

class IntcodeComputer
  attr_accessor :memory, :pointer, :stdout, :stdin, :state, :relative_base

  def initialize
    @memory = []
    @pointer = 0
    @stdout = []
    @stdin = []
    @state = :initialize
    @relative_base = 0
  end

  def load(program)
    @memory = program.clone
    @pointer = 0
  end

  def waiting?
    @state == :waiting
  end

  def finished?
    @state == :finished
  end

  def execute(&each_step)
    @state = :processing

    loop do
      yield if block_given?
      step
      break if @state == :waiting || @state == :finished
    end

    @memory[0]
  end

  def step
    case @memory[@pointer] % 100
    when 1 # ADD
      a = get_parameter(1)
      b = get_parameter(2)
      c = get_address(3)

      @memory[c] = a + b
      @pointer += 4
    when 2 # MULTIPLY
      a = get_parameter(1)
      b = get_parameter(2)
      c = get_address(3)

      @memory[c] = a * b
      @pointer += 4
    when 3 # INPUT
      a = get_address(1)

      if (value = @stdin.shift)
        @memory[a] = value
        @pointer += 2
      else
        @state = :waiting
      end
    when 4 # OUTPUT
      a = get_parameter(1)

      @stdout << a
      @pointer += 2
    when 5 # JUMP_IF_TRUE
      a = get_parameter(1)
      b = get_parameter(2)

      if a != 0
        @pointer = b
      else
        @pointer += 3
      end
    when 6 # JUMP_IF_FALSE
      a = get_parameter(1)
      b = get_parameter(2)

      if a == 0
        @pointer = b
      else
        @pointer += 3
      end
    when 7 # LESS_THAN
      a = get_parameter(1)
      b = get_parameter(2)
      c = get_address(3)

      @memory[c] = a < b ? 1 : 0
      @pointer += 4
    when 8 # EQUALS
      a = get_parameter(1)
      b = get_parameter(2)
      c = get_address(3)

      @memory[c] = a == b ? 1 : 0
      @pointer += 4
    when 9 # BOOST
      a = get_parameter(1)

      @relative_base += a
      @pointer += 2
    when 99 # EXIT
      @state = :finished
    else
      raise "Unknown INTCODE #{@memory[@pointer]}"
    end
  end

  def get_parameter(offset)
    @memory[get_address(offset)] || 0
  end

  def get_address(offset)
    intcode = @memory[@pointer]
    mode = (intcode / (10 ** (offset + 1))) % 10

    case mode
    when 1 # POSITION_MODE
      @pointer + offset
    when 2 # RELATIVE_MODE
      @memory[@pointer + offset] + @relative_base
    else
      @memory[@pointer + offset]
    end
  end

  def dump
    longest = @memory.map { |addr| addr || 0 }.max.digits.size
    index = 0
    output = "\n"

    @memory.each_slice(15) do |page|
      page.each do |address|
        if index == @pointer
          output << address.to_i.to_s.rjust(longest, ' ').red
        else
          output << address.to_i.to_s.rjust(longest, ' ')
        end

        output << ' '

        index += 1
      end
      output << "\n"
    end

    output << "\n\n"
  end
end

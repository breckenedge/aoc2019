# Intcode program first used in Advent of Code - Day 2

require 'colorize'

class IntcodeComputer
  # INTCODEs
  ADD = 1
  MULTIPLY = 2
  INPUT = 3
  OUTPUT = 4
  JUMP_IF_TRUE = 5
  JUMP_IF_FALSE = 6
  LESS_THAN = 7
  EQUALS = 8
  BOOST = 9
  EXIT = 99

  POSITION_MODE = 1
  RELATIVE_MODE = 2

  attr_accessor :memory, :pointer, :stdout, :stdin, :waiting, :halted, :relative_base

  def initialize
    @memory = []
    @pointer = 0
    @stdout = []
    @stdin = []
    @halted = false
    @waiting = false
    @relative_base = 0
  end

  def load(program)
    @memory = program.clone
    @pointer = 0
  end

  def execute(&each_step)
    @waiting = false

    loop do
      yield if block_given?
      step
      break if @waiting || @halted
    end

    @memory[0]
  end

  def step
    case @memory[@pointer] % 100
    when ADD
      add
    when MULTIPLY
      multiply
    when INPUT
      input
    when OUTPUT
      output
    when JUMP_IF_TRUE
      jump_if_true
    when JUMP_IF_FALSE
      jump_if_false
    when LESS_THAN
      less_than
    when EQUALS
      equals
    when BOOST
      boost
    when EXIT
      @halted = true
    else
      raise "Unknown INTCODE #{@memory[@pointer]}"
    end
  end

  def get_parameter(offset)
    @memory[get_address(offset)] || 0
  end

  def get_address(offset)
    intcode = @memory[@pointer]
    digits = intcode.digits
    mode = digits[1 + offset]

    case mode
    when POSITION_MODE
      @pointer + offset
    when RELATIVE_MODE
      @memory[@pointer + offset] + @relative_base
    else
      @memory[@pointer + offset]
    end
  end

  # 1
  def add
    a = get_parameter(1)
    b = get_parameter(2)
    c = get_address(3)

    @memory[c] = a + b
    @pointer += 4
  end

  # 2
  def multiply
    a = get_parameter(1)
    b = get_parameter(2)
    c = get_address(3)

    @memory[c] = a * b
    @pointer += 4
  end

  # 3
  def input
    a = get_address(1)

    if value = @stdin.shift
      @memory[a] = value
      @pointer += 2
    else
      @waiting = true
    end
  end

  # 4
  def output
    a = get_parameter(1)

    @stdout << a
    @pointer += 2
  end

  # 5
  def jump_if_true
    a = get_parameter(1)
    b = get_parameter(2)

    if a != 0
      @pointer = b
    else
      @pointer += 3
    end
  end

  # 6
  def jump_if_false
    a = get_parameter(1)
    b = get_parameter(2)

    if a == 0
      @pointer = b
    else
      @pointer += 3
    end
  end

  # 7
  def less_than
    a = get_parameter(1)
    b = get_parameter(2)
    c = get_address(3)

    @memory[c] = a < b ? 1 : 0
    @pointer += 4
  end

  # 8
  def equals
    a = get_parameter(1)
    b = get_parameter(2)
    c = get_address(3)

    @memory[c] = a == b ? 1 : 0
    @pointer += 4
  end

  # 9
  def boost
    a = get_parameter(1)

    @relative_base += a
    @pointer += 2
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

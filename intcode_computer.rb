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
    intcode = extract_intcode(@memory[@pointer])

    case intcode
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
      raise "Unknown INTCODE #{intcode}"
    end
  end

  # 1
  def add
    a, b = extract_parameters
    @memory[@memory[@pointer + 3]] = a + b
    @pointer += 4
  end

  # 2
  def multiply
    a, b = extract_parameters
    @memory[@memory[@pointer + 3]] = a * b
    @pointer += 4
  end

  # 3
  def input
    a, b = extract_locations

    if value = @stdin.shift
      @memory[a] = value
      @pointer += 2
    else
      @waiting = true
    end
  end

  # 4
  def output
    a, b = extract_parameters

    @stdout << a
    @pointer += 2
  end

  # 5
  def jump_if_true
    a, b = extract_parameters

    if a != 0
      @pointer = b
    else
      @pointer += 3
    end
  end

  # 6
  def jump_if_false
    a, b = extract_parameters

    if a == 0
      @pointer = b
    else
      @pointer += 3
    end
  end

  # 7
  def less_than
    a, b = extract_parameters

    @memory[@memory[@pointer + 3]] = a < b ? 1 : 0
    @pointer += 4
  end

  # 8
  def equals
    a, b = extract_parameters

    @memory[@memory[@pointer + 3]] = a == b ? 1 : 0
    @pointer += 4
  end

  # 9
  def boost
    a, b = extract_parameters
    @relative_base += a
    @pointer += 2
  end

  def extract_intcode(intcode)
    intcode.digits.reverse.last(2).map(&:to_s).join.to_i
  end

  def extract_locations
    digits = @memory[@pointer].to_s.rjust(4, '0').chars.map(&:to_i)

    a = case digits[1]
        when RELATIVE_MODE
          @memory[@pointer + 1] + @relative_base
        when POSITION_MODE
          @pointer + 1
        else
          @memory[@pointer + 1]
        end

    b = case digits[0]
        when RELATIVE_MODE
          @memory[@pointer + 2] + @relative_base
        when POSITION_MODE
          @pointer + 2
        else
          @memory[@pointer + 2]
        end

    [a, b]
  end

  def extract_parameters
    a, b = extract_locations

    [@memory[a] || 0, @memory[b] || 0]
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

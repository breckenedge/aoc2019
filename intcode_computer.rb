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
  EXIT = 99

  attr_accessor :memory, :pointer, :stdout, :stdin

  def initialize
    @memory = []
    @pointer = 0
    @stdout = []
    @stdin = []
  end

  def load(program)
    @memory = program.clone
    @pointer = 0
  end

  def execute(&each_step)
    loop do
      yield if block_given?

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
      when EXIT
        break
      else
        raise "Unknown INTCODE #{intcode}"
      end
    end

    @memory[0]
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
    @memory[@memory[@pointer + 1]] = @stdin.shift
    @pointer += 2
  end

  # 4
  def output
    @stdout << @memory[@memory[@pointer + 1]]
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

  def extract_intcode(intcode)
    intcode.digits.reverse.last(2).map(&:to_s).join.to_i
  end

  def extract_parameters
    digits = @memory[@pointer].to_s.rjust(5, '0').chars.map(&:to_i)

    a = if digits[2] == 0
          @memory[@memory[@pointer + 1]]
        else
          @memory[@pointer + 1]
        end

    b = if digits[1] == 0
          @memory[@memory[@pointer + 2]]
        else
          @memory[@pointer + 2]
        end

    [a, b]
  end

  def dump
    longest = @memory.max.digits.size
    index = 0
    output = "\n"

    @memory.each_slice(15) do |page|
      page.each do |address|
        if index == @pointer
          output << address.to_s.rjust(longest, ' ').red
        else
          output << address.to_s.rjust(longest, ' ')
        end

        index += 1
      end
      output << "\n"
    end

    output << "\n\n"
  end
end

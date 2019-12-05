# Intcode program first used in Advent of Code - Day 2

class IntcodeProgram
  # INTCODEs
  ADD = 1
  MULTIPLY = 2
  INPUT = 3
  OUTPUT = 4
  EXIT = 99

  attr_accessor :memory, :i

  def initialize(memory)
    @memory = memory
    @pointer = 0
  end

  def run
    loop do
      intcode = @memory[@pointer]

      if intcode.digits.size > 2
        intcode = intcode.digits.reverse.last(2).map(&:to_s).join.to_i
      end

      if intcode == ADD
        add(*@memory[@pointer, 4])
      elsif intcode == MULTIPLY
        multiply(*@memory[@pointer, 4])
      elsif intcode == INPUT
        input(@memory[@pointer + 1])
      elsif intcode == OUTPUT
        output(@memory[@pointer + 1])
      elsif EXIT
        break
      else
        raise "Unknown INTCODE #{intcode}"
      end
      puts @memory.join(',')
    end

    @memory[0]
  end

  def add(mode, input_1, input_2, output)
    digits = mode.to_s.rjust(5, '0').chars.map(&:to_i)

    a = if digits[2] == 0
          @memory[input_1]
        else
          input_1
        end

    b = if digits[1] == 0
          @memory[input_2]
        else
          input_2
        end

    @memory[output] = a + b
    @pointer += 4
  end

  def multiply(mode, input_1, input_2, output)
    digits = mode.to_s.rjust(5, '0').chars.map(&:to_i)

    a = if digits[2] == 0
          @memory[input_1]
        else
          input_1
        end

    b = if digits[1] == 0
          @memory[input_2]
        else
          input_2
        end

    @memory[output] = a * b
    @pointer += 4
  end
  
  def input(address)
    print "Feed me: "
    @memory[address] = gets.chomp.to_i
    @pointer += 2
  end

  def output(address)
    puts(@memory[address])
    @pointer += 2
  end
end

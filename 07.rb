#!/usr/bin/ruby

require './intcode_computer.rb'

# Advent of Code template in the Ruby programming language

def preprocess_input(input)
  input.split(',').map(&:to_i)
end

def solution_1(input)
  [0, 1, 2, 3, 4].reverse.permutation.map do |sequence|
    computers = 5.times.map do |i|
      computer = IntcodeComputer.new
      computer.load(input)
      computer
    end

    output = 0

    result = computers.each_with_index.map do |computer, index|
      computer.stdin << sequence[index]
      computer.stdin << output
      computer.execute
      output = computer.stdout[0]
    end

    result.last
  end.max
end

def solution_2(input)
  [5, 6, 7, 8, 9].reverse.permutation.map do |sequence|
    computers = 5.times.map do |i|
      computer = IntcodeComputer.new
      computer.load(input)
      computer
    end

    computers.each_with_index do |computer, index|
      computer.stdin << sequence[index]
    end

    outputs = [[], [], [], [], [0]]

    loop do
      computers.each_with_index.map do |computer, index|
        computer.stdin << outputs[index - 1].shift

        computer.execute

        if computer.stdout.any?
          outputs[index] << computer.stdout.shift
        end
      end

      break if computers.none?(&:waiting)
    end

    outputs.last.last
  end.max
end

INPUT = <<~EOS
3,8,1001,8,10,8,105,1,0,0,21,30,39,64,81,102,183,264,345,426,99999,3,9,1001,9,2,9,4,9,99,3,9,1002,9,4,9,4,9,99,3,9,1002,9,5,9,101,2,9,9,102,3,9,9,1001,9,2,9,1002,9,2,9,4,9,99,3,9,1002,9,3,9,1001,9,5,9,1002,9,3,9,4,9,99,3,9,102,4,9,9,1001,9,3,9,102,4,9,9,1001,9,5,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,99
EOS

INPUT_EXAMPLE_1 = <<~EOS
3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0
EOS

INPUT_EXAMPLE_2 = <<~EOS
3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0
EOS

INPUT_EXAMPLE_3 = <<~EOS
3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5
EOS

INPUT_EXAMPLE_4 = <<~EOS
3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10
EOS

def main
  input = preprocess_input(INPUT)

  input_example_1 = preprocess_input(INPUT_EXAMPLE_1)
  puts "Example Solution 1: #{solution_1(input_example_1)}"

  input_example_2 = preprocess_input(INPUT_EXAMPLE_2)
  puts "Example Solution 2: #{solution_1(input_example_2)}"

  puts "Solution 1: #{solution_1(input)}"

  input_example_3 = preprocess_input(INPUT_EXAMPLE_3)
  puts "Example Solution 3: #{solution_2(input_example_3)}"

  input_example_4 = preprocess_input(INPUT_EXAMPLE_4)
  puts "Example Solution 4: #{solution_2(input_example_4)}"

  puts "Solution 2: #{solution_2(input)}"
end

if __FILE__ == $0
  main
end

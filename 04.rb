#!/usr/bin/ruby

# Advent of Code template in the Ruby programming language

INPUT = <<~EOS
158126-624574
EOS

INPUT_EXAMPLE_1 = <<~EOS
EOS

INPUT_EXAMPLE_2 = <<~EOS
EOS

def main
  input = preprocess_input(INPUT)
  input_example_1 = preprocess_input(INPUT_EXAMPLE_1)
  input_example_2 = preprocess_input(INPUT_EXAMPLE_2)
  puts "Preprocessed input: #{input}"
  #puts "Example Solution 1: #{solution_1(input_example_1)}"
  puts "Solution 1: #{solution_1(input)}"
  #puts "Example Solution 2: #{solution_2(input_example_2)}"
  puts "Solution 2: #{solution_2(input)}"
end

def preprocess_input(input)
  nums = input.split('-').map(&:to_i)
  Range.new(nums[0], nums[1])
end

def increasing?(digits)
  prev_digit = digits[0]

  digits[1..-1].each do |digit|
    if digit > prev_digit
      return false
    end

    prev_digit = digit
  end

  return true
end

def adj_pair?(digits)
  last_digit = digits[0]
  paired = false
  
  digits[1..-1].each do |digit|
    if digit == last_digit
      return true
    end

    last_digit = digit
  end

  paired
end

def even_groups?(digits)
  last_digit = digits[0]
  groups = [[last_digit]]
  digits[1..-1].each do |digit|
    if digit == groups.last.last
      groups.last << digit
    else
      groups << [digit]
    end
  end
  group_sizes = groups.map(&:size)
  group_sizes.include?(2)
end

def solution_1(input)
  input.select do |int|
    digits = int.digits

    adj_pair?(digits) && increasing?(digits)
  end.size
end

def solution_2(input)
  input.select do |int|
    digits = int.digits

    adj_pair?(digits) && increasing?(digits) && even_groups?(digits)
  end.size
end

if __FILE__ == $0
  main
end

INPUT = <<~EOS
EOS

INPUT_EXAMPLE_1 = <<~EOS
EOS

INPUT_EXAMPLE_2 = <<~EOS
EOS

def main
  input = preprocess_input(INPUT)
  input_example_1 = preprocess_input(INPUT_EXAMPLE_1)
  input_example_2 = preprocess_input(INPUT_EXAMPLE_2)
  puts "Example Solution 1: #{solution_1(input_example_1)}"
  puts "Solution 1: #{solution_1(input)}"
  puts "Example Solution 2: #{solution_2(input_example_2)}"
  puts "Solution 2: #{solution_2(input)}"
end

def preprocess_input(input)
  output = ""
end

def solution_1(input)
  output = ""
end

def solution_2(input)
  output = ""
end

if __FILE__ == $0
  main
end

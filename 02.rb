require './intcode_computer.rb'
require './intcode_program_input_seeker.rb'

input = DATA.readlines[0].split(',').map(&:to_i)
part_1_input = input.clone
part_1_input[1] = 12
part_1_input[2] = 2

puts "Part 1: #{IntcodeComputer.new.run(part_1_input)}"
puts "Part 2: #{IntcodeProgramInputSeeker.new.seek(program: input, goal: 19690720, noun_range: (0..99), verb_range: (0..99)).join}"

__END__
1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,6,19,1,9,19,23,2,23,10,27,1,27,5,31,1,31,6,35,1,6,35,39,2,39,13,43,1,9,43,47,2,9,47,51,1,51,6,55,2,55,10,59,1,59,5,63,2,10,63,67,2,9,67,71,1,71,5,75,2,10,75,79,1,79,6,83,2,10,83,87,1,5,87,91,2,9,91,95,1,95,5,99,1,99,2,103,1,103,13,0,99,2,14,0,0

require './intcode_computer.rb'

class IntcodeProgramInputSeeker
  # Find the input noun and verb that provide the goal output.
  def seek(program:, goal:, noun_range: (0..99), verb_range: (0..99), computer_type: IntcodeComputer)
    noun_verb_pairs = noun_range.map { |noun| verb_range.map { |verb| [noun, verb] } }.flatten(1)

    noun_verb_pairs.each do |noun, verb|
      computer = computer_type.new
      this_program = program.clone
      this_program[1] = noun
      this_program[2] = verb

      if computer.run(this_program) == goal
        return [noun, verb]
      else
        next
      end
    end
  end
end

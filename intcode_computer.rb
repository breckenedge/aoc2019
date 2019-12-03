# Intcode program first used in Advent of Code - Day 2

class IntcodeProgram
  # INTCODEs
  ADD = 1
  MULTIPLY = 2
  EXIT = 99

  def run(memory)
    i = 0

    loop do
      noun_pos = memory[i + 1]
      verb_pos = memory[i + 2]
      output_pos = memory[i + 3]
      noun = memory[noun_pos]
      verb = memory[verb_pos]

      case memory[i]
      when ADD
        memory[output_pos] = noun + verb
      when MULTIPLY
        memory[output_pos] = noun * verb
      when EXIT
        return memory[0]
      else
        raise "Unknown INTCODE #{memory[i]}"
      end

      i += 4
    end

    nil
  end
end

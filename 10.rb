#!/usr/bin/ruby

# Advent of Code template in the Ruby programming language

def preprocess_input(input)
  input.split
end

def solution_1(input)
  counts = Hash.new { |h, k| h[k] = [] }

  input.each_with_index do |row, y|
    row.each_char.with_index do |cell, x|
      next if cell == '.'

      count = 0

      0.upto(3).each do |quadrant|
        count += get_slopes_in_quadrant(input, x, y, quadrant).count
      end

      counts[count] << [[x, y]]
    end
  end

  counts.max
end

def get_slopes_in_quadrant(input, x, y, quadrant)
  slopes = []

  input.each_with_index do |row, curr_y|
    row.each_char.with_index do |cell, curr_x|
      next if cell == '.'
      next if x == curr_x && y == curr_y # skip self

      case quadrant
      when 0
        next unless curr_x < x && curr_y < y
      when 1
        next unless curr_x >= x && curr_y < y
      when 2
        next unless curr_x >= x && curr_y >= y
      when 3
        next unless curr_x < x && curr_y >= y
      end

      if y - curr_y == 0
        if x > curr_x
          slopes << [1, 0]
        else
          slopes << [-1, 0]
        end
      elsif x - curr_x == 0
        if y > curr_y
          slopes << [0, 1]
        else
          slopes << [0, -1]
        end
      else
        slopes << Rational(x - curr_x, y - curr_y)
      end
    end
  end

  slopes.uniq
end

def solution_2(input)
  lazer = solution_1(input)[1]

  200.times do |i|
    0.upto(3).each do |quadrant|
      get_slopes_in_quadrant(input, lazer[0], lazer[1], quadrant)
    end
  end
end

INPUT = <<~EOS
.###..#......###..#...#
#.#..#.##..###..#...#.#
#.#.#.##.#..##.#.###.##
.#..#...####.#.##..##..
#.###.#.####.##.#######
..#######..##..##.#.###
.##.#...##.##.####..###
....####.####.#########
#.########.#...##.####.
.#.#..#.#.#.#.##.###.##
#..#.#..##...#..#.####.
.###.#.#...###....###..
###..#.###..###.#.###.#
...###.##.#.##.#...#..#
#......#.#.##..#...#.#.
###.##.#..##...#..#.#.#
###..###..##.##..##.###
###.###.####....######.
.###.#####.#.#.#.#####.
##.#.###.###.##.##..##.
##.#..#..#..#.####.#.#.
.#.#.#.##.##########..#
#####.##......#.#.####.
EOS

INPUT_EXAMPLE_0 = <<~EOS
.#..#
.....
#####
....#
...##
EOS

INPUT_EXAMPLE_1 = <<~EOS
......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####
EOS

INPUT_EXAMPLE_2 = <<~EOS
#.#...#.#.
.###....#.
.#....#...
##.#.#.#.#
....#.#.#.
.##..###.#
..#...##..
..##....##
......#...
.####.###.
EOS

def main
  input_example_0 = preprocess_input(INPUT_EXAMPLE_0)
  puts "Example Solution 0: #{solution_1(input_example_0)}"

  input_example_1 = preprocess_input(INPUT_EXAMPLE_1)
  puts "Example Solution 1: #{solution_1(input_example_1)}"

  input_example_2 = preprocess_input(INPUT_EXAMPLE_2)
  puts "Example Solution 2: #{solution_1(input_example_2)}"

  input = preprocess_input(INPUT)
  puts "Solution 1: #{solution_1(input)}"

  puts "Solution 2: #{solution_2(input)}"
end


if __FILE__ == $0
  main
end

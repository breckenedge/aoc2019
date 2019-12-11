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

      counts[count] << [x, y]
    end
  end

  counts.max
end

# NOTE: This is buggy
def solution_2(input)
  center = solution_1(input)[1][0]
  input[center[1]][center[0]] = 'O'
  quadrant = 0
  count = 0
  slopes = []
  astroid = nil

  loop do
    if slopes.empty?
      quadrant = (quadrant + 1) % 4

      # This is buggy for slopes like 1/0 or 0/1 in some quadrants.
      slopes = get_slopes_in_quadrant(input, center[0], center[1], quadrant).sort_by { |point|
        case quadrant
        when 1, 3
          point[1].to_f / point[0]
        else
          point[0].to_f / point[1]
        end
      }
    end

    slope = slopes.pop
    astroid = first_astroid_on_slope(input, center[0], center[1], slope, quadrant)
    input[astroid[1]][astroid[0]] = '.'

    puts "Quadrant: #{quadrant}"
    puts input
    puts
    sleep 0.01

    count += 1

    break if count == 200
  end

  astroid[0] * 100 + astroid[1]
end

def first_astroid_on_slope(input, x, y, slope, quadrant)
  curr_x = x
  curr_y = y

  loop do
    case quadrant
    when 0
      curr_x = curr_x - slope[0]
      curr_y = curr_y - slope[1]
    when 1
      curr_x = curr_x + slope[0]
      curr_y = curr_y - slope[1]
    when 2
      curr_x = curr_x + slope[0]
      curr_y = curr_y + slope[1]
    when 3
      curr_x = curr_x - slope[0]
      curr_y = curr_y + slope[1]
    end

    if input[curr_y][curr_x] != '.'
      return [curr_x, curr_y]
    end
  end
end

# Quadrants:
#
# 3|0
# -+-
# 2|1

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
          slopes << [1, 0] # Right
        else
          slopes << [-1, 0] # Left
        end
      elsif x - curr_x == 0
        if y > curr_y
          slopes << [0, 1] # Up
        else
          slopes << [0, -1] # Down
        end
      else
        rational = Rational(x - curr_x, y - curr_y)
        slopes << [rational.numerator.abs, rational.denominator.abs]
      end
    end
  end

  slopes.uniq
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

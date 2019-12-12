#!/usr/bin/ruby

# Advent of Code template in the Ruby programming language

def preprocess_input(input)
  input.split("\n").map do |line|
    x, y, z = line.gsub!('<', '').gsub!('>', '').split(',').map { |param| param.split('=').last.to_i }
    Moon.new(x: x, y: y, z: z)
  end
end

def solution_1(moons, steps = 1000)
  steps.times.each do
    pairs = [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]]

    # Apply gravity
    pairs.each do |pair|
      a = moons[pair[0]]
      b = moons[pair[1]]

      [:x, :y, :z].each do |pos|

        if a.send(pos) > b.send(pos)
          a.send("v#{pos}=".to_sym, a.send("v#{pos}") - 1)
          b.send("v#{pos}=".to_sym, b.send("v#{pos}") + 1)
        elsif a.send(pos) < b.send(pos)
          a.send("v#{pos}=".to_sym, a.send("v#{pos}") + 1)
          b.send("v#{pos}=".to_sym, b.send("v#{pos}") - 1)
        else
        end
      end
    end

    # Apply velocity
    moons.each do |moon|
      moon.x += moon.vx
      moon.y += moon.vy
      moon.z += moon.vz
    end
  end

  moons.sum(&:total_energy)
end

def solution_2(moons)
  visited = [moons.to_s]

  loop do
    pairs = [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]]

    # Apply gravity
    pairs.each do |pair|
      a = moons[pair[0]]
      b = moons[pair[1]]

      [:x, :y, :z].each do |pos|

        if a.send(pos) > b.send(pos)
          a.send("v#{pos}=".to_sym, a.send("v#{pos}") - 1)
          b.send("v#{pos}=".to_sym, b.send("v#{pos}") + 1)
        elsif a.send(pos) < b.send(pos)
          a.send("v#{pos}=".to_sym, a.send("v#{pos}") + 1)
          b.send("v#{pos}=".to_sym, b.send("v#{pos}") - 1)
        else
        end
      end
    end

    # Apply velocity
    moons.each do |moon|
      moon.x += moon.vx
      moon.y += moon.vy
      moon.z += moon.vz
    end

    if visited.include?(moons.to_s)
      break
    else
      visited << moons.to_s
    end
  end

  visited.count
end

class Moon
  attr_accessor :x, :y, :z, :vx, :vy, :vz

  def initialize(x:, y:, z:)
    # Position
    @x = x
    @y = y
    @z = z

    # Velocity
    @vx = 0
    @vy = 0
    @vz = 0
  end

  def to_s
    "x: #{x} y: #{y} z: #{z} vx: #{vx} vy: #{vy} vz: #{vz}"
  end

  def kinetic_energy
    vx.abs + vy.abs + vz.abs
  end

  def potential_energy
    x.abs + y.abs + z.abs
  end

  def total_energy
    kinetic_energy * potential_energy
  end
end

INPUT = <<~EOS
<x=-19, y=-4, z=2>
<x=-9, y=8, z=-16>
<x=-4, y=5, z=-11>
<x=1, y=9, z=-13>
EOS

INPUT_EXAMPLE_1 = <<~EOS
<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>
EOS

INPUT_EXAMPLE_2 = <<~EOS
<x=-8, y=-10, z=0>
<x=5, y=5, z=10>
<x=2, y=-7, z=3>
<x=9, y=-8, z=-3>
EOS

def main
  input_example_1 = preprocess_input(INPUT_EXAMPLE_1)
  puts "Example Solution 1: #{solution_1(input_example_1, 10)}"

  input_example_2 = preprocess_input(INPUT_EXAMPLE_2)
  puts "Example Solution 2: #{solution_1(input_example_2, 100)}"

  input = preprocess_input(INPUT)

  puts "Solution 1: #{solution_1(input)}"

  input_example_2 = preprocess_input(INPUT_EXAMPLE_2)
  puts "Example Solution 2: #{solution_2(input_example_1)}"

  puts "Solution 2: #{solution_2(input)}"
end

if __FILE__ == $0
  main
end

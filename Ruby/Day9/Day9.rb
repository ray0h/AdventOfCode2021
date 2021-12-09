# https://adventofcode.com/2021/day/9

# --- Day 9: Smoke Basin ---
# These caves seem to be lava tubes. Parts are even still volcanically active; small hydrothermal vents release smoke into the caves that slowly settles like rain.

# If you can model how the smoke flows through the caves, you might be able to avoid it and be that much safer. The submarine generates a heightmap of the floor of the nearby caves for you (your puzzle input).

# Smoke flows to the lowest point of the area it's in. For example, consider the following heightmap:

# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
# Each number corresponds to the height of a particular location, where 9 is the highest and 0 is the lowest a location can be.

# Your first goal is to find the low points - the locations that are lower than any of its adjacent locations. Most locations have four adjacent locations (up, down, left, and right); locations on the edge or corner of the map have three or two adjacent locations, respectively. (Diagonal locations do not count as adjacent.)

# In the above example, there are four low points, all highlighted: two are in the first row (a 1 and a 0), one is in the third row (a 5), and one is in the bottom row (also a 5). All other locations on the heightmap have some lower adjacent location, and so are not low points.

# The risk level of a low point is 1 plus its height. In the above example, the risk levels of the low points are 2, 1, 6, and 6. The sum of the risk levels of all low points in the heightmap is therefore 15.

# Find all of the low points on your heightmap. What is the sum of the risk levels of all low points on your heightmap?

# --- Part Two ---
# Next, you need to find the largest basins so you know what areas are most important to avoid.

# A basin is all locations that eventually flow downward to a single low point. Therefore, every low point has a basin, although some basins are very small. Locations of height 9 do not count as being in any basin, and all other locations will always be part of exactly one basin.

# The size of a basin is the number of locations within the basin, including the low point. The example above has four basins.

# The top-left basin, size 3:

# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
# The top-right basin, size 9:

# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
# The middle basin, size 14:

# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
# The bottom-right basin, size 9:

# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
# Find the three largest basins and multiply their sizes together. In the above example, this is 9 * 14 * 9 = 1134.

# What do you get if you multiply together the sizes of the three largest basins?

require 'benchmark'

path = '/home/roh/Projects/AdventOfCode2021/data/Day9.txt'
data = File.open(path).read.split("\n")

matrix = []
data.each { |line| matrix.push(line.split('').map(&:to_i)) }

# Part1
puts Benchmark.measure {
  low_sums = []
  matrix.each_with_index do |row, y|
    row_length = row.length
    col_length = matrix.length
    row.each_with_index do |c, x|
      north = y-1 < 0 ? nil : matrix[y-1][x]
      south = y+1 == col_length ? nil : matrix[y+1][x]
      west = x-1 < 0 ? nil : matrix[y][x-1]
      east = x+1 == row_length ? nil : matrix[y][x+1]
      surrounding = [north, east, west, south].compact
      low_sums.push(c) if surrounding.filter{ |el| el < c }.empty? && c != 9
    end
  end
  
  p "Sum of all low point risks: #{low_sums.map{|el| el+1}.reduce(&:+)}"
}

# Part2
puts Benchmark.measure {

  def eval_neighbors(coord, matrix)
    x, y = coord
    neighbor_coords = []
    neighbor_coords.push([x+1, y]) unless x+1 >= matrix[0].length
    neighbor_coords.push([x-1, y]) unless x-1 < 0 
    neighbor_coords.push([x, y-1]) unless y-1 < 0 
    neighbor_coords.push([x, y+1]) unless y+1 >= matrix.length
    neighbor_coords
  end
  
  # use queue to traverse across the space
  basins = []
  visited = []
  matrix.each_with_index do |row, y|
    row.each_with_index do |col, x|
      next if visited.include?([x,y])
      basin = []
      stack = [[x,y]]
      until stack.empty?
        xo, yo = stack.shift
        unless matrix[yo][xo] == 9
          basin.push([xo, yo]) 
          neighbors = eval_neighbors([xo,yo], matrix) 
          neighbors.each{ |neighbor| stack.push(neighbor) unless stack.include?(neighbor) || visited.include?(neighbor) }
        end
        visited.push([xo, yo])
        # p "#{visited.length}, #{matrix[0].length * matrix.length}"
      end
      basins.push(basin.length) unless basin.empty?
    end
  end
  
  basins = basins.sort{|a, b| b <=> a}

  p "Product of three biggest basins : #{basins.first(3).reduce(&:*)}"
  
}
  
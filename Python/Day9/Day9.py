#!/usr/bin/python3

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

from operator import add, mul
from functools import reduce

path = '/home/roh/Projects/AdventOfCode2021/data/Day9.txt'
with open(path) as f:
  matrix = [ list(map(int, list(line.rstrip()))) for line in f]

# Part1
low_sums = []
for y in range(len(matrix)):
  for x in range(len(matrix[0])):
    val = matrix[y][x]
    north = None if y-1 < 0 else matrix[y-1][x]
    south = None if y+1 == len(matrix) else matrix[y+1][x]
    west = None if x-1 < 0 else matrix[y][x-1]
    east = None if x+1 == (len(matrix[0])) else matrix[y][x+1]
    surrounding = list(filter(lambda x: x != None, [north, east, west, south]))
    if len(list(filter(lambda x: x < val, surrounding))) == 0 and val != 9:
      low_sums.append(val)

print("Sum of all low point risks: " + str(reduce(add, [el + 1 for el in low_sums])))

# Part2
def eval_neighbors(coord, matrix):
  x,y = coord
  neighbor_coords = []
  if x+1 < len(matrix[0]): neighbor_coords.append([x+1,y])
  if x-1 >= 0: neighbor_coords.append([x-1, y])
  if y-1 >= 0: neighbor_coords.append([x, y-1])
  if y+1 < len(matrix): neighbor_coords.append([x, y+1])
  return neighbor_coords

basins = []
visited = []
for y in range(len(matrix)):
  for x in range(len(matrix[0])):
    if [x,y] in visited: continue
    basin = []
    stack = [[x,y]]
    while len(stack) > 0:
      xo, yo = stack.pop(0)
      if matrix[yo][xo] != 9:
        basin.append([xo, yo])
        neighbors = eval_neighbors([xo,yo], matrix)
        for neighbor in neighbors:
          if neighbor not in visited and neighbor not in stack:
            stack.append(neighbor)
      visited.append([xo, yo])
    if len(basin) > 0: basins.append(len(basin))
  
basins.sort(reverse=True)
product = reduce(mul, basins[0:3])

print("Product of three biggest basins: " + str(product))
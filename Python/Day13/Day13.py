#! /usr/bin/python3

# https://adventofcode.com/2021/day/13

# --- Day 13: Transparent Origami ---
# You reach another volcanically active part of the cave. It would be nice if you could do some kind of thermal imaging so you could tell ahead of time which caves are too hot to safely enter.

# Fortunately, the submarine seems to be equipped with a thermal camera! When you activate it, you are greeted with:

# Congratulations on your purchase! To activate this infrared thermal imaging
# camera system, please enter the code found on page 1 of the manual.
# Apparently, the Elves have never used this feature. To your surprise, you manage to find the manual; as you go to open it, page 1 falls out. It's a large sheet of transparent paper! The transparent paper is marked with random dots and includes instructions on how to fold it up (your puzzle input). For example:

# 6,10
# 0,14
# 9,10
# 0,3
# 10,4
# 4,11
# 6,0
# 6,12
# 4,1
# 0,13
# 10,12
# 3,4
# 3,0
# 8,4
# 1,10
# 2,14
# 8,10
# 9,0

# fold along y=7
# fold along x=5
# The first section is a list of dots on the transparent paper. 0,0 represents the top-left coordinate. The first value, x, increases to the right. The second value, y, increases downward. So, the coordinate 3,0 is to the right of 0,0, and the coordinate 0,7 is below 0,0. The coordinates in this example form the following pattern, where # is a dot on the paper and . is an empty, unmarked position:

# ...#..#..#.
# ....#......
# ...........
# #..........
# ...#....#.#
# ...........
# ...........
# ...........
# ...........
# ...........
# .#....#.##.
# ....#......
# ......#...#
# #..........
# #.#........
# Then, there is a list of fold instructions. Each instruction indicates a line on the transparent paper and wants you to fold the paper up (for horizontal y=... lines) or left (for vertical x=... lines). In this example, the first fold instruction is fold along y=7, which designates the line formed by all of the positions where y is 7 (marked here with -):

# ...#..#..#.
# ....#......
# ...........
# #..........
# ...#....#.#
# ...........
# ...........
# -----------
# ...........
# ...........
# .#....#.##.
# ....#......
# ......#...#
# #..........
# #.#........
# Because this is a horizontal line, fold the bottom half up. Some of the dots might end up overlapping after the fold is complete, but dots will never appear exactly on a fold line. The result of doing this fold looks like this:

# #.##..#..#.
# #...#......
# ......#...#
# #...#......
# .#.#..#.###
# ...........
# ...........
# Now, only 17 dots are visible.

# Notice, for example, the two dots in the bottom left corner before the transparent paper is folded; after the fold is complete, those dots appear in the top left corner (at 0,0 and 0,1). Because the paper is transparent, the dot just below them in the result (at 0,3) remains visible, as it can be seen through the transparent paper.

# Also notice that some dots can end up overlapping; in this case, the dots merge together and become a single dot.

# The second fold instruction is fold along x=5, which indicates this line:

# #.##.|#..#.
# #...#|.....
# .....|#...#
# #...#|.....
# .#.#.|#.###
# .....|.....
# .....|.....
# Because this is a vertical line, fold left:

# #####
# #...#
# #...#
# #...#
# #####
# .....
# .....
# The instructions made a square!

# The transparent paper is pretty big, so for now, focus on just completing the first fold. After the first fold in the example above, 17 dots are visible - dots that end up overlapping after the fold is completed count as a single dot.

# How many dots are visible after completing just the first fold instruction on your transparent paper?

# --- Part Two ---
# Finish folding the transparent paper according to the instructions. The manual says the code is always eight capital letters.

# What code do you use to activate the infrared thermal imaging camera system?

path = "/home/roh/Projects/AdventOfCode2021/data/Day13.txt"

with open(path) as f:
  data = [line.rstrip() for line in f]

# separate points from instructions
points = []
folds = []
for line in data:
  if "," in line:
    points.append([int(no) for no in line.split(",")])
  elif "fold" in line:
    folds.append(line)


# create transparency sheet
maxX = max([el[0] for el in points])+1
maxY = max([el[1] for el in points])+1 

sheet = [['.' for i in range(maxX)] for j in range(maxY)]

for pair in points:
  sheet[pair[1]][pair[0]] = "#"

def flatten(lst):
  l = lst.copy()
  return [item for sublist in l for item in sublist]

def foldY(sheet, yline):
  midpt = int(len(sheet)/2)
  top = sheet[0:yline]
  bot = sheet[yline+1:len(sheet)]
  if yline < midpt:
    for y in range(len(top)):
      for x in range(len(top[y])):
        if top[y][x] == "#":
          bot[yline-1-y][x] = "#"
    return bot
  else:
    for y in range(len(bot)):
      for x in range(len(bot[y])):
        if bot[y][x] == "#":
          top[yline-1-y][x] = "#"
    return top
  # return bot if yline < midpt else top

def foldX(sheet, xline):
  midpt = int(len(sheet[0])/2)
  if xline < midpt:
    for y in range(len(sheet)):
      for x in range(xline):
        if sheet[y][x] == "#":
          sheet[y][2*xline-x] = "#"
    return [row[xline+1:len(row)] for row in sheet]
  else:
    for y in range(len(sheet)):
      for x in range(xline+1,len(sheet[0])):
        if sheet[y][x] == '#':
          sheet[y][x-2*(x-xline)] = "#"
    return [row[0:xline] for row in sheet]

def count_dots(sheet):
  return flatten(sheet).count("#")

def get_instruction(string):
  words, val = string.split("=")
  axis = "x" if "x" in words else "y"
  return [axis, int(val)]

first = get_instruction(folds[0])
f = foldX(sheet, first[1]) if first[0] == 'x' else foldY(sheet, first[1])

print("Part 1 - No of dots after first fold: " + str(count_dots(f)))

# Part2
cur_sheet = []
f = []

for row in sheet:
  cur_sheet.append(row)

for fold in folds:
  current = get_instruction(fold)
  if current[0] == 'x':
    f = foldX(cur_sheet, current[1]) 
  else:
    f = foldY(cur_sheet, current[1])
 
  cur_sheet = []
  for row in f:
    cur_sheet.append(row)

print("Part 2 - Message:")

for r in f:
  print("".join(r))
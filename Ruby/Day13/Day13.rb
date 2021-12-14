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

require 'pry'

# get data
path = "/home/roh/Projects/AdventOfCode2021/data/Day13.txt"

data = File.open(path).read.split("\n")

# separate points from instructions
points = []
folds = []
data.each do |line|
  if line.include?(",")
    points.push line.split(",").map(&:to_i) 
  elsif line.include?("fold")
    folds.push(line)
  end
end

# create transparency sheet

maxX = points.map{|el| el[0]}.max + 1
maxY = points.map{|el| el[1]}.max + 1

sheet = Array.new(maxY) { Array.new(maxX) {'.'} }
points.each { |pair| sheet[pair[1]][pair[0]] = "#" }

def foldY(sheet, yline)
  midpt = sheet.length/2
  top = sheet.slice(0,yline)
  bot = sheet.slice(yline+1, sheet.length)
  if yline < midpt
    top.each_with_index do |row, y|
      row.each_with_index { |el, x| bot[yline-1-y][x] = '#'  if el == '#' }
    end 
  else # yline >= midpt
    bot.each_with_index do |row, y|
      row.each_with_index { |el, x| top[yline-1-y][x] = '#' if el == '#' }
    end
  end
  return yline < midpt ? bot : top
end

def foldX(sheet, xline)
  midpt = sheet[0].length/2
  if xline < midpt
    sheet.each_with_index do |row, y|
      0.upto(xline-1) { |x| sheet[y][2*xline-x] = '#' if sheet[y][x] == '#' }
    end
    return sheet.map{|row| row.slice(xline+1, row.length-1)}
  else # xline >= midpt
    sheet.each_with_index do |row, y|
      (xline+1).upto(row.length-1) { |x| sheet[y][x-2*(x-xline)] = '#' if sheet[y][x] == '#' }
    end
    return sheet.map{|row| row.slice(0, xline)}
  end
end

def count_dots(sheet)
  sheet.flatten.count("#")
end

def get_instruction(str)
  words, val = str.split("=")
  axis = words.include?("x") ? "x" : "y"
  [axis, val.to_i]
end

first = get_instruction(folds[0])
f = first[0] == 'x' ? foldX(sheet, first[1]) : f = foldY(sheet, first[1])

p "Part 1 - No of dots after first fold: #{count_dots(f)}"

# Part2
cur_sheet = []
sheet.each {|row| cur_sheet.push(row)}
folds.each do |fold|
  current = get_instruction(fold)
  f = current[0] == 'x' ? foldX(cur_sheet, current[1]) : foldY(cur_sheet, current[1])

  cur_sheet = []
  f.each {|row| cur_sheet.push(row)}
end

p "Part 2 - Message:"
f.each {|r| p r.join}
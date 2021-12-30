# Follow up using basic Djikstra algorithm took ~1min for Part 1 - after seeing 
# Part 2, knew would need something more elegant and faster.

require 'pry'
require 'benchmark'

path = "/home/roh/Projects/AdventOfCode2021/data/Day15.txt"

data = File.open(path).read.split("\n")

matrix = []
data.each {|line| matrix.push(line.split("").map(&:to_i))}

def getNeighbors(coords, maxX, maxY)
  xo, yo = coords
  neighbors = [[xo+1, yo], [xo-1, yo], [xo, yo+1], [xo, yo-1]]
  neighbors.reject{|coord| coord[0] < 0 || coord[1] < 0 || coord[0] > maxX || coord[1] > maxY}
end


def currentLows(hash, visited)
  avail = hash.clone
  visited.each {|coords| avail.delete(coords)} 
  lowest = avail.values.min
  avail.select{|k,v| v == lowest}.keys
end

puts Benchmark.measure {
  # set 
  risks = {}
  0.upto(matrix[0].length-1) do |y|
    0.upto(matrix.length-1) do |x|
      risks[[x,y]] = Float::INFINITY
    end
  end
  risks[[0,0]] = 0

  visited = []
  finish = [matrix[0].length-1, matrix.length-1]
  
  until visited.include?(finish)
    queue = currentLows(risks, visited)
    
    queue.each do |coords|
      neighbors = getNeighbors(coords, matrix[0].length-1, matrix.length-1)
      neighbors.each do |neighbor|
        next if visited.include?(neighbor)
        risk = matrix[neighbor[1]][neighbor[0]]
        risks[neighbor] = risks[coords] + risk if risks[coords] + risk < risks[neighbor]
      end
      visited.push(coords)
    end
  end

  p "Best path total risk: #{risks[finish]}"
}

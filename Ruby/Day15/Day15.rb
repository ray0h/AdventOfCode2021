# Initial naive implementation takes ~5 min for Part 1

require 'pry'
require 'benchmark'

path = "/home/roh/Projects/AdventOfCode2021/data/Day15.txt"

data = File.open(path).read.split("\n")

matrix = []
data.each {|line| matrix.push(line.split("").map(&:to_i))}

def riskSum(path, matrix)
  path.map{|coord| matrix[coord[1]][coord[0]] }.reduce(&:+) - matrix[0][0]
end

def getNeighbors(coords, maxX, maxY)
  xo, yo = coords
  neighbors = [[xo+1, yo], [xo-1, yo], [xo, yo+1], [xo, yo-1]]
  neighbors.reject{|coord| coord[0] < 0 || coord[1] < 0 || coord[0] > maxX || coord[1] > maxY}
end

puts Benchmark.measure {
  spotRisk = {}
  0.upto(matrix.length-1) do |y|
    0.upto(matrix[0].length-1) do |x|
      spotRisk[[x,y]] = 9*matrix.length*matrix[0].length
    end
  end
  lowestRisk = 9*(matrix.length*matrix[0].length)

  finish = [matrix[0].length-1, matrix.length-1]
  bestPath = []
  queue = [[[0,0], []]]
  
  until queue.empty?
    coords, path = queue.shift

    nextPath = []
    path.each {|p| nextPath.push(p)}
    nextPath.push(coords)

    risk = riskSum(nextPath, matrix)
    next if spotRisk[coords] <= risk
    
    spotRisk[coords] = risk
    if coords == finish
      if risk < lowestRisk
        bestPath = []
        nextPath.each {|p| bestPath.push(p)}
        lowestRisk = risk
      end
      next
    end
    
    neighbors = getNeighbors(coords, matrix[0].length-1, matrix.length-1)
    neighbors.each do |neighbor|
      queue.push([neighbor, nextPath]) unless nextPath.include?(neighbor) || spotRisk[neighbor] < risk
    end
  end
  
  p "Best path has total risk: #{riskSum(bestPath, matrix)}"
  p bestPath.map{|el| matrix[el[1]][el[0]]}
  matrix.each {|r| p r.join} 
}
# Tired of trying, looked online for faster solutions:
# https://github.com/daniero/code-challenges/blob/master/aoc2021/ruby/15.rb#L5

# A couple of really nice pieces of code using sets and priority queue.  
# Solution for Part 1 took < 1s....
require 'set'
require 'pqueue'
require 'benchmark'

# interesting use of yield to iterate through each valid neighbor
def eachNeighbor(matrix, (x,y))
  yield [x,y-1] if y > 0
  yield [x+1,y] if x+1 < matrix[y].length
  yield [x,y+1] if y+1 < matrix.length
  yield [x-1,y] if x > 0
end

def findPath(matrix)
  start = [0,0]
  finish = [matrix[0].length-1, matrix.length-1]
  
  # by making visited a set data structure, can use .add?() method, which returns nil if not part of a set and simultaneously adds the value.  
  visited = Set[]
  initial = [start, 0]
  
  # priority queue reshuffles the queue based on the given criteria; here it is the order of the risk from lowest to greatest (most progressed to end?)
  queue = PQueue.new([initial]) {|a,b| a.last < b.last }
  until queue.empty?
    coords, risk = queue.pop
    
    next unless visited.add?(coords) #add? method!
    return risk if coords == finish
    
    # this is the beauty of ruby usind yield / blocks to add to the queue
    eachNeighbor(matrix, coords) { |x,y|
      queue.push([ [x,y], risk + matrix[y][x] ])
    }
  end
end

path = "/home/roh/Projects/AdventOfCode2021/data/Day15.txt"
data = File.open(path).read.split("\n")
matrix = []
data.each {|line| matrix.push(line.split("").map(&:to_i))}

# Part 1
puts Benchmark.measure {
  best = findPath(matrix)
  p "Best path has total risk: #{best}"
}

# Part 2
def increaseLine(line, risk)
  line.map{ |el| el+risk == 9 ? 9 : (el+risk)%9 }
end

def increaseMatrix(matrix, risk)
  matrix.map { |line| increaseLine(line, risk) }
end

def create5x5tile(matrix)
  # lengthen rows
  lengthened = matrix.map {|line| 
    line + increaseLine(line, 1) + increaseLine(line, 2) + increaseLine(line, 3) + increaseLine(line, 4)
  }

  # lengthen columns
  base = lengthened.clone
  1.upto(4) do |i|
    increased = increaseMatrix(base, i)
    increased.each {|line| lengthened.push(line)}
  end

  lengthened
end

# p increaseLine([1,2,3,4,5,6,7,8,9], 2)

puts Benchmark.measure {
  biggerMatrix = create5x5tile(matrix)
  # biggerMatrix.each {|r| p r.map(&:to_s).join }
  best = findPath(biggerMatrix)
  p "Best path in actual grid has risk: #{best}"
}
  
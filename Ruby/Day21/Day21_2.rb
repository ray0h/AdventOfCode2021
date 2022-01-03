require 'benchmark'

puts Benchmark.measure {

  pos = [10-1, 3-1]
  tot = [0,0]
  r = 1
  p = 1
  
  while tot[p] < 1000 do
    p = 1 - p
    pos[p] = (pos[p] + 3*r + 3) % 10
    tot[p] += pos[p] + 1
    r += 3
  end
  
  p "Losing score: #{tot.min}, Last roll: #{r-1}, product: #{tot.min*(r-1)}"
}


def wins(p1,t1,p2,t2)
  roll_freq = [[3,1], [4,3], [5,6], [6,7], [7,6], [8,3],[9,1]]
  return [0,1] if t2 <= 0  # p2 has won (never p1 since p1 about to move)
  
  w1,w2 = [0,0]
  roll_freq.each do |r,f|
    c2,c1 = wins(p2,t2,(p1+r)%10,t1-1-(p1+r)%10) # p2 about to move
    w1,w2 = [w1+f*c1, w2+f*c2]
    # p "#{w1}, #{w2}"
  end
  [w1,w2]
end

puts Benchmark.measure {
  p "Bigger universes: #{wins(9,21,2,21).max}"
}
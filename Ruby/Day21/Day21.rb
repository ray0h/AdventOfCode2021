# https://adventofcode.com/2021/day/21

# --- Day 21: Dirac Dice ---
# There's not much to do as you slowly descend to the bottom of the ocean. The submarine computer challenges you to a nice game of Dirac Dice.

# This game consists of a single die, two pawns, and a game board with a circular track containing ten spaces marked 1 through 10 clockwise. Each player's starting space is chosen randomly (your puzzle input). Player 1 goes first.

# Players take turns moving. On each player's turn, the player rolls the die three times and adds up the results. Then, the player moves their pawn that many times forward around the track (that is, moving clockwise on spaces in order of increasing value, wrapping back around to 1 after 10). So, if a player is on space 7 and they roll 2, 2, and 1, they would move forward 5 times, to spaces 8, 9, 10, 1, and finally stopping on 2.

# After each player moves, they increase their score by the value of the space their pawn stopped on. Players' scores start at 0. So, if the first player starts on space 7 and rolls a total of 5, they would stop on space 2 and add 2 to their score (for a total score of 2). The game immediately ends as a win for any player whose score reaches at least 1000.

# Since the first game is a practice game, the submarine opens a compartment labeled deterministic dice and a 100-sided die falls out. This die always rolls 1 first, then 2, then 3, and so on up to 100, after which it starts over at 1 again. Play using this die.

# For example, given these starting positions:

# Player 1 starting position: 4
# Player 2 starting position: 8
# This is how the game would go:

# Player 1 rolls 1+2+3 and moves to space 10 for a total score of 10.
# Player 2 rolls 4+5+6 and moves to space 3 for a total score of 3.
# Player 1 rolls 7+8+9 and moves to space 4 for a total score of 14.
# Player 2 rolls 10+11+12 and moves to space 6 for a total score of 9.
# Player 1 rolls 13+14+15 and moves to space 6 for a total score of 20.
# Player 2 rolls 16+17+18 and moves to space 7 for a total score of 16.
# Player 1 rolls 19+20+21 and moves to space 6 for a total score of 26.
# Player 2 rolls 22+23+24 and moves to space 6 for a total score of 22.
# ...after many turns...

# Player 2 rolls 82+83+84 and moves to space 6 for a total score of 742.
# Player 1 rolls 85+86+87 and moves to space 4 for a total score of 990.
# Player 2 rolls 88+89+90 and moves to space 3 for a total score of 745.
# Player 1 rolls 91+92+93 and moves to space 10 for a final score, 1000.
# Since player 1 has at least 1000 points, player 1 wins and the game ends. At this point, the losing player had 745 points and the die had been rolled a total of 993 times; 745 * 993 = 739785.

# Play a practice game using the deterministic 100-sided die. The moment either player wins, what do you get if you multiply the score of the losing player by the number of times the die was rolled during the game?

# To begin, get your puzzle input.

# --- Part Two ---
# Now that you're warmed up, it's time to play the real game.

# A second compartment opens, this time labeled Dirac dice. Out of it falls a single three-sided die.

# As you experiment with the die, you feel a little strange. An informational brochure in the compartment explains that this is a quantum die: when you roll it, the universe splits into multiple copies, one copy for each possible outcome of the die. In this case, rolling the die always splits the universe into three copies: one where the outcome of the roll was 1, one where it was 2, and one where it was 3.

# The game is played the same as before, although to prevent things from getting too far out of hand, the game now ends when either player's score reaches at least 21.

# Using the same starting positions as in the example above, player 1 wins in 444356092776315 universes, while player 2 merely wins in 341960390180808 universes.

# Using your given starting positions, determine every possible outcome. Find the player that wins in more universes; in how many universes does that player win?

# --- Part Two ---
# Now that you're warmed up, it's time to play the real game.

# A second compartment opens, this time labeled Dirac dice. Out of it falls a single three-sided die.

# As you experiment with the die, you feel a little strange. An informational brochure in the compartment explains that this is a quantum die: when you roll it, the universe splits into multiple copies, one copy for each possible outcome of the die. In this case, rolling the die always splits the universe into three copies: one where the outcome of the roll was 1, one where it was 2, and one where it was 3.

# The game is played the same as before, although to prevent things from getting too far out of hand, the game now ends when either player's score reaches at least 21.

# Using the same starting positions as in the example above, player 1 wins in 444356092776315 universes, while player 2 merely wins in 341960390180808 universes.

# Using your given starting positions, determine every possible outcome. Find the player that wins in more universes; in how many universes does that player win?

require 'benchmark'
require 'pry'

def move(spot, spaces)
  spot = (spot + spaces) % 10
  spot = 10 if spot.zero?
  spot
end

def get_rolls(die)
  first = die+1 > 100 ? die+1 - 100 : die+1
  second = die+2 > 100 ? die+2 - 100 : die+2
  third = die+3 > 100 ? die+3 - 100 : die+3
  rolls = first+second+third
end

path = "/home/roh/Projects/AdventOfCode2021/data/Day21.txt"
data = File.open(path).read.split("\n")

p1_spot = data[0].scan(/\d+/).last.to_i
p2_spot = data[1].scan(/\d+/).last.to_i
p1_score = 0
p2_score = 0

# Part 1
puts Benchmark.measure {

  no_rolls = 0
  turns = 0
  die = 0
  loop do
    # p1 turn
    # roll die three times
    rolls = get_rolls(die)
    die = die+3 > 100 ? die+3-100 : die+3
    no_rolls += 3
  
    # move player 1 token and score
    p1_spot = move(p1_spot, rolls)
    p1_score += p1_spot
    break if p1_score >= 1000
  
    # p2 turn
    # roll die three times
    rolls = get_rolls(die)
    die = die+3 > 100 ? die+3-100 : die+3
    no_rolls += 3
  
    # move player 1]2 token
    p2_spot = move(p2_spot, rolls)
    p2_score += p2_spot
    break if p2_score >= 1000
  
    turns += 1
    # p "no_rolls: #{no_rolls}; p1: #{p1_spot}, #{p1_score}, p2: #{p2_spot}, #{p2_score}, set: #{die}"
  end
  p "FINAL; no_rolls: #{no_rolls}; p1: #{p1_spot}, #{p1_score}, p2: #{p2_spot}, #{p2_score}, set: #{die}"
  p "Part 1 - no rolls * losing player score: #{no_rolls*(p2_score < p1_score ? p2_score : p1_score)}"
}
  
  
  # Part2
# game status = [rolls, p1=>{spot, score}, p2=>{spot, score}, turn: 0/1 p1/p2]
poss_coords = [
  [1,1,1], [1,1,2], [1,1,3], [1,2,1], [1,2,2], [1,2,3], [1,3,1], [1,3,2], [1,3,3],
  [2,1,1], [2,1,2], [2,1,3], [2,2,1], [2,2,2], [2,2,3], [2,3,1], [2,3,2], [2,3,3],
  [3,1,1], [3,1,2], [3,1,3], [3,2,1], [3,2,2], [3,2,3], [3,3,1], [3,3,2], [3,3,3]
]
total_poss = poss_coords.map{|coord| coord.reduce(&:+) }
poss = total_poss.uniq
counts = poss.map{ |p| total_poss.count(p) }

queue = []
poss.each do |rolls|
  queue.push([rolls, {'spot'=>p1_spot, 'score'=>0}, {'spot'=>p2_spot, 'score'=>0}, 0, counts[poss.index(rolls)]])
end

p1_spot = data[0].scan(/\d+/).last.to_i
p2_spot = data[1].scan(/\d+/).last.to_i
p1_wins = 0
p2_wins = 0
max_length = 0
# until queue.empty? 
#   p "#{queue.length}, p1: #{p1_wins}, p2: #{p2_wins}"
#   # parse current turn info
#   rolls, p1, p2, turn, paths = queue.shift
  
#   # evaluate moves / scoring for current turn
#   if turn.zero? 
#     p1['spot'] = move(p1['spot'], rolls)
#     p1['score'] += p1['spot']
#   else
#     p2['spot'] = move(p2['spot'], rolls)
#     p2['score'] += p2['spot']
#   end

#   # evaluate if win / game over
#   if turn.zero? 
#     if p1['score'] >= 21
#       p1_wins += paths
#       next
#     else
#       poss.each { |rolls| queue.push([rolls, p1.clone, p2.clone, 1, paths*counts[poss.index(rolls)]]) }
#     end
#   else
#     if p2['score'] >= 21
#       p2_wins += paths
#       next
#     else
#       poss.each { |rolls| queue.push([rolls, p1.clone, p2.clone, 0, paths*counts[poss.index(rolls)]]) }
#     end
#   end
#   # binding.pry if queue.length > 4000000
# end

# p p1_wins, p2_wins
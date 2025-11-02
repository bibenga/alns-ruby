require 'set'
require_relative "../lib/alns"
require_relative "../lib/state"
require_relative "../lib/accept"
require_relative "../lib/select"
require_relative "../lib/stop"

def run_tsp
  dists = make_dists(COORDS)
  
  nodes = Array.new(COORDS.length)
  COORDS.each_with_index do |coord, i| 
    nodes[i] = i
  end

	alns = ALNS.new(Random.new(1234))

  init_sol = TspState.new(nodes, {}, dists)
	init_sol = greedy_repair(init_sol, alns.rnd)

	puts "optimal solution: 564"
	puts "initial solution: %.4f" % init_sol.objective

	alns.listener do |outcome, cand| 
		# puts "%-6s %.4f" % [Outcome.to_s(outcome), cand.objective]
	end

	alns.add_destroy_operator do |state, rnd| 
		random_removal(state, rnd)
	end 
	alns.add_destroy_operator do |state, rnd| 
		path_removal(state, rnd)
	end 
	alns.add_destroy_operator do |state, rnd| 
		worst_removal(state, rnd)
	end 

	alns.add_repair_operator do |state, rnd| 
		greedy_repair(state, rnd)
	end

	num_destroy = alns.destroy_operators.length
	num_repair = alns.repair_operators.length

	select = RouletteWheel.new([3, 2, 1, 0.5], 0.8, num_destroy, num_repair)
	accept = HillClimbing.new
	stop = MaxIterations.new(1000)

	res = alns.iterate(init_sol, select, accept, stop)
	# pp res
	best = res.best_state

	puts "best solution: %.4f" % best.objective

	# neato -Tpng tmp/tsp.dot -o tmp/tsp.png
	write_dot_file("tmp/tsp.dot", COORDS, best.edges)
end

COORDS = [
	[0, 13],
	[0, 26],
	[0, 27],
	[0, 39],
	[2, 0],
	[5, 13],
	[5, 19],
	[5, 25],
	[5, 31],
	[5, 37],
	[5, 43],
	[5, 8],
	[8, 0],
	[9, 10],
	[10, 10],
	[11, 10],
	[12, 10],
	[12, 5],
	[15, 13],
	[15, 19],
	[15, 25],
	[15, 31],
	[15, 37],
	[15, 43],
	[15, 8],
	[18, 11],
	[18, 13],
	[18, 15],
	[18, 17],
	[18, 19],
	[18, 21],
	[18, 23],
	[18, 25],
	[18, 27],
	[18, 29],
	[18, 31],
	[18, 33],
	[18, 35],
	[18, 37],
	[18, 39],
	[18, 41],
	[18, 42],
	[18, 44],
	[18, 45],
	[25, 11],
	[25, 15],
	[25, 22],
	[25, 23],
	[25, 24],
	[25, 26],
	[25, 28],
	[25, 29],
	[25, 9],
	[28, 16],
	[28, 20],
	[28, 28],
	[28, 30],
	[28, 34],
	[28, 40],
	[28, 43],
	[28, 47],
	[32, 26],
	[32, 31],
	[33, 15],
	[33, 26],
	[33, 29],
	[33, 31],
	[34, 15],
	[34, 26],
	[34, 29],
	[34, 31],
	[34, 38],
	[34, 41],
	[34, 5],
	[35, 17],
	[35, 31],
	[38, 16],
	[38, 20],
	[38, 30],
	[38, 34],
	[40, 22],
	[41, 23],
	[41, 32],
	[41, 34],
	[41, 35],
	[41, 36],
	[48, 22],
	[48, 27],
	[48, 6],
	[51, 45],
	[51, 47],
	[56, 25],
	[57, 12],
	[57, 25],
	[57, 44],
	[61, 45],
	[61, 47],
	[63, 6],
	[64, 22],
	[71, 11],
	[71, 13],
	[71, 16],
	[71, 45],
	[71, 47],
	[74, 12],
	[74, 16],
	[74, 20],
	[74, 24],
	[74, 29],
	[74, 35],
	[74, 39],
	[74, 6],
	[77, 21],
	[78, 10],
	[78, 32],
	[78, 35],
	[78, 39],
	[79, 10],
	[79, 33],
	[79, 37],
	[80, 10],
	[80, 41],
	[80, 5],
	[81, 17],
	[84, 20],
	[84, 24],
	[84, 29],
	[84, 34],
	[84, 38],
	[84, 6],
	[107, 27],
]

def make_dists(coords)
  n = coords.length
	m = Array.new(n, 0)
  coords.each_with_index do |coord1, row|
    m[row] = Array.new(n, 0)
    coords.each_with_index do |coord2, col|
      m[row][col] = euclidean(coord1[0], coord1[1], coord2[0], coord2[1])
    end
  end
	return m
end

def euclidean(x1, y1, x2, y2)
  Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
end

class TspState < State
	attr_accessor :nodes, :edges, :dists

  def initialize(nodes, edges, dists)
    @nodes = nodes
    @edges = edges
    @dists = dists
  end

  def initialize_copy(original)
    super
    @nodes = original.nodes
    @edges = original.edges.dup
    @dists = original.dists
  end

	def objective
		v = 0.0
		@edges.each do |from, to|
			v += @dists[from][to]
		end
		return v
	end
end

def greedy_repair(state, rnd) 
	visited = state.edges.values

	nodes = state.nodes.shuffle

	while state.edges.length != state.nodes.length
		node = nodes.find(-> {-1}) do |other|
			!state.edges.key?(other)
		end
		# p node
		if node == -1
			raise "node not found"
		end

		unvisited = state.nodes.select do |other|
			other != node && !visited.include?(other) && !would_form_subcycle(node, other, state) 
		end
		# p unvisited
		if unvisited.length == 0
			raise "unvisited is empty"
		end

		nearest = unvisited.min do |a, b|
			state.dists[node][a] <=> state.dists[node][b]
		end
		# p nearest

		state.edges[node] = nearest
		visited << nearest

		# break
	end

	return state
end

def would_form_subcycle(from_node, to_node, state)
	n = state.nodes.length
	(1...n).each do |step|
		if !state.edges.key?(to_node)
			return false
		end
		to_node = state.edges[to_node]
		if from_node == to_node && step != n-1
			return true
		end
	end
	return false
end

DEGREE_OF_DESTRUCTION = 0.1

def edges_to_remove(state)
	(state.edges.length * DEGREE_OF_DESTRUCTION).to_i
end

def random_removal(state, rnd)
	# puts "random_removal"
	destroyed = state.clone
	# pp destroyed.edges

	to_remove = edges_to_remove(destroyed)
	# p to_remove

	removed = 0
	while removed < to_remove
		node = destroyed.nodes.sample
		# puts "#{node}; removed=#{removed}; to_remove=#{to_remove}; ?=#{destroyed.edges.key?(node)}"
		if destroyed.edges.key?(node)
			removed += 1
			destroyed.edges.delete(node)
		end
	end

	return destroyed
end


def path_removal(state, rnd) 
	destroyed = state.clone

	node = destroyed.nodes.sample

	to_remove = edges_to_remove(destroyed)
	(0...to_remove).each do |idx|
		nextNode = destroyed.edges[node]
		destroyed.edges.delete(node)
		node = nextNode
	end

	return destroyed
end

def worst_removal(state, rnd) 
	destroyed = state.clone

	worst_edges = destroyed.nodes.clone
	worst_edges = worst_edges.sort do |a, b|
  	destroyed.dists[a][destroyed.edges[a]] <=> destroyed.dists[b][destroyed.edges[b]]
	end

	to_remove = edges_to_remove(destroyed)
	(0...to_remove).each do |idx|
		destroyed.edges.delete(worst_edges[worst_edges.length-(idx+1)])
	end

	return destroyed
end

def write_dot_file(filename, nodes, edges)
  # scale up
  k = 1
  nodes = nodes.map { |x, y| [x * k, y * k] }

  # search min and max
  min_x = nodes[0][0]
  min_y = nodes[0][1]
  max_x = min_x
  max_y = min_y

  nodes.each do |x, y|
    min_x = x if x < min_x
    min_y = y if y < min_y
    max_x = x if x > max_x
    max_y = y if y > max_y
  end

  width = max_x - min_x
  raise "zero width" if width == 0
  height = max_y - min_y
  raise "zero height" if height == 0

  # create and write dot file
  File.open(filename, "w") do |f|
    f.puts "digraph G {"
    f.puts "  graph [size=\"#{width},#{height}!\", dpi=20.0];"

    fontsize = 48
    node_size = 2
    nodes.each_with_index do |(x, y), i|
      adj_x = x - min_x
      adj_y = y - min_y
      f.puts "  #{i} [label=\"#{i}\", fontsize=#{fontsize}, pos=\"#{adj_x},#{adj_y}!\", shape=circle, width=#{node_size}, height=#{node_size}, fixedsize=true];"
    end

    arrowsize = 4
    penwidth = 3
    edges.each do |from, to|
      f.puts "  #{from} -> #{to} [arrowsize=#{arrowsize}, penwidth=#{penwidth}];"
    end

    f.puts "}"
  end
end

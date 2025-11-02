require_relative "math"

class Select
  def select(rnd, best, current) 
    raise "unimplemented"
  end

  def update(candidate, d_idx, r_idx, outcome)
    raise "unimplemented"
  end
end

class RouletteWheel < Select
  def initialize(scores, decay, num_destroy, num_repair, op_coupling = nil)
    @scores = scores
    @decay = decay
    @num_destroy = num_destroy
    @num_repair = num_repair
    @op_coupling = op_coupling

    @d_weights = Array.new(num_destroy, 1)
    @r_weights = Array.new(num_repair, 1)

    @op_coupling = op_coupling

    # scores          [4]float64 // representing the weight updates when the candidate solution results in a new global
    # decay           float64    // operator decay parameter :math:`\theta \in [0, 1]`
    # numDestroy      int        // number of destroy operators
    # numRepair       int        // number of repair operators
    # opCoupling      [][]bool   // boolean matrix that indicates coupling between destroy and repair operators
    # dWeights        []float64  // the weights of the destroy operators
    # rWeights        []float64  // the weights of the repair operators
    # coupledRIdcs    []int      // used in Select for caching
    # coupledRWeights []float64  // used in Select for caching
  end

  def select(rnd, best, current) 
    if @op_coupling
      raise "unimplemented"
    else
      d_idx = weighted_random_index(rnd, @d_weights)
		  r_idx = weighted_random_index(rnd, @r_weights)
		  return d_idx, r_idx
    end
  end

  def update(candidate, d_idx, r_idx, outcome)
    @d_weights[d_idx] *= @decay
    @d_weights[d_idx] += (1 - @decay) * @scores[outcome]

    @r_weights[r_idx] *= @decay
    @r_weights[r_idx] += (1 - @decay) * @scores[outcome]
  end
end
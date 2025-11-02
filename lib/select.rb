require_relative "math"

class Select
  def initialize(num_destroy, num_repair, op_coupling = nil)
    if num_destroy <= 0 || num_repair <= 0
        raise ArgumentError, "Missing destroy or repair operators."
    end

    @num_destroy = num_destroy
    @num_repair = num_repair
    @op_coupling = op_coupling
  end

  def select(rnd, best, current) 
    raise "unimplemented"
  end

  def update(candidate, d_idx, r_idx, outcome)
    raise "unimplemented"
  end
end

class RouletteWheel < Select
  def initialize(scores, decay, num_destroy, num_repair, op_coupling = nil)
    super(num_destroy, num_repair, op_coupling)

    @scores = scores
    @decay = decay

    @d_weights = Array.new(num_destroy, 1)
    @r_weights = Array.new(num_repair, 1)
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
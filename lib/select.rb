require_relative "math"

class Select
  def initialize(num_destroy, num_repair, op_coupling = nil)
    if num_destroy <= 0 || num_repair <= 0
        raise ArgumentError, "Missing destroy or repair operators."
    end
    if op_coupling
      rows = op_coupling.length
      cols = op_coupling[0].length

      if rows != num_destroy || cols != num_repair
        raise ArgumentError, "coupling matrix of shape (#{rows}, #{cols}), expected (#{num_destroy}, #{num_repair})"
      end

      op_coupling.each_with_index do |row, i|
        if row.length != cols
          raise ArgumentError, "the number of columns in a row #{i} does not match the expected #{cols}"
        end

        coupled = row.any? { |b| b }
        if !coupled 
          raise ArgumentError, "destroy operator #{i} has no coupled repair operators"
        end
      end
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
      d_idx = weighted_random_index(rnd, @d_weights)

      coupled_r_idcs = []
      coupled_r_weights = []
      @op_coupling.my_array.each_with_index do |coupled, i|
        if coupled
          coupled_r_idcs << i
          coupled_r_weights << @r_weights[i]
        end
      end

      r_idx = coupled_r_idcs[weightedRandomIndex(rnd, coupled_r_weights)]

      return d_idx, r_idx
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
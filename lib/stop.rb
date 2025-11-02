class Stop
  def done?(rnd, best, current)
    raise "unimplemented"
  end
end

class MaxIterations < Stop  
  def initialize(max_iterations)
    @max_iterations = max_iterations
    @current_iteration = 0
  end

  def done?(rnd, best, current)
    @current_iteration += 1
  	return @current_iteration > @max_iterations
  end
end
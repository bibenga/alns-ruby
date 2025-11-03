class Stop
  def done?(rnd, best, current)
    raise NotImplementedError
  end
end

class MaxIterations < Stop
  def initialize(max_iterations)
    @max_iterations = max_iterations
    @current_iteration = 0
  end

  def done?(rnd, best, current)
    @current_iteration += 1
    @current_iteration > @max_iterations
  end
end

class MaxRuntime < Stop
  def initialize(max_runtime)
    @max_runtime = max_runtime
    @started = nil
  end

  def done?(rnd, best, current)
    if @started.nil?
      @started = Time.new
      return false
    end
    elapsed = Time.now - @started
    elapsed > @max_runtime
  end
end

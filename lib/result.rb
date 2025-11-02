class Result
  def initialize(best, statistics)
    @best = best
    @statistics = statistics
  end

  def best_state
    @best
  end

  def statistics
    @statistics
  end
end
class Result
  def initialize(best, statistics)
    @best = best
    @statistics = statistics
  end

  def best_state
    @best
  end

  attr_reader :statistics
end

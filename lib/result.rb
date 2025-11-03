class Result
  attr_reader :best_state, :statistics

  def initialize(best, statistics)
    @best_state = best
    @statistics = statistics
  end
end

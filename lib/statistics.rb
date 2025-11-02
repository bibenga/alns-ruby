class Statistics
  def initialize(num_destroy, num_repair)
    @runtimes = []
    @objectives = []

    @destroy_operator_counts = Array.new(num_destroy) { [0, 0, 0, 0] }
    @repair_operator_counts = Array.new(num_repair) { [0, 0, 0, 0] }
  end

  def collect_objective(time, objective)
    @runtimes << time
    @objectives << objective
  end

  def collect_operators(didx, ridx, outcome)
    @destroy_operator_counts[didx][outcome] += 1
    @repair_operator_counts[ridx][outcome] += 1
  end

end
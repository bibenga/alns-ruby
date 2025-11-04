# frozen_string_literal: true

module ALNS
  class Statistics
    attr_reader :runtimes, :objectives, :destroy_operator_counts, :repair_operator_counts

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

    def collect_operators(d_idx, r_idx, outcome)
      @destroy_operator_counts[d_idx][outcome] += 1
      @repair_operator_counts[r_idx][outcome] += 1
    end

    def freeze
      @runtimes.freeze
      @objectives.freeze
      destroy_operator_counts.each(&:freeze)
      @destroy_operator_counts.freeze
      repair_operator_counts.each(&:freeze)
      @repair_operator_counts.freeze
    end
  end
end

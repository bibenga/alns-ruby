# frozen_string_literal: true

require 'alns/outcome'
require 'alns/statistics'
require 'alns/result'

module ALNS
  class Solver
    attr_reader :rnd, :destroy_operators, :repair_operators

    def initialize(rnd = nil)
      @rnd = rnd || Random.new
      @on_outcome = nil
      @destroy_operators = []
      @repair_operators = []
    end

    def on_outcome(&block)
      @on_outcome = block
    end

    def add_destroy_operator(&block)
      @destroy_operators << block
    end

    def add_repair_operator(&block)
      @repair_operators << block
    end

    def iterate(initial_solution, select, accept, stop)
      if @destroy_operators.empty? || @repair_operators.empty?
        raise ArgumentError, 'Missing destroy or repair operators.'
      end

      curr = initial_solution
      best = initial_solution

      stats = Statistics.new(@destroy_operators.length, @repair_operators.length)

      stats.collect_objective(Time.new, initial_solution.objective)

      until stop.done?(@rng, best, curr)
        d_idx, r_idx = select.select(@rnd, best, curr)

        destroy_op = @destroy_operators[d_idx]
        repair_op = @repair_operators[r_idx]

        destroyed = destroy_op.call(curr, @rnd)
        cand = repair_op.call(destroyed, @rnd)

        best, curr, outcome = eval_cand(accept, best, curr, cand)

        select.update(cand, d_idx, r_idx, outcome)

        # stats.IterationCount += 1
        stats.collect_objective(Time.new, curr.objective)
        stats.collect_operators(d_idx, r_idx, outcome)
      end

      stats.freeze

      Result.new(best, stats)
    end

    private

    def eval_cand(accept, best, curr, cand)
      outcome = determine_outcome(accept, best, curr, cand)

      @on_outcome&.call(outcome, cand)

      case outcome
      when Outcome::BEST
        [cand, cand, outcome]
      when Outcome::REJECT
        [best, curr, outcome, nil]
      else
        [best, cand, outcome, nil]
      end
    end

    def determine_outcome(accept, best, curr, cand)
      outcome = Outcome::REJECT

      if accept.accept?(@rnd, best, curr, cand)
        outcome = Outcome::ACCEPT

        outcome = Outcome::BETTER if cand.objective < curr.objective
      end

      outcome = Outcome::BEST if cand.objective < best.objective

      outcome
    end
  end
end

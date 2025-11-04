# frozen_string_literal: true

require 'alns/select/base'
require 'alns/math'

module ALNS
  module Select
    class RouletteWheel < Base
      def initialize(scores, decay, num_destroy, num_repair, op_coupling = nil)
        super(num_destroy, num_repair, op_coupling)

        @scores = scores
        @decay = decay

        @d_weights = Array.new(num_destroy, 1)
        @r_weights = Array.new(num_repair, 1)
      end

      def select(rnd, best, current)
        if @op_coupling
          d_idx = ALNS.weighted_random_index(rnd, @d_weights)

          coupled_r_idcs = []
          coupled_r_weights = []
          @op_coupling[d_idx].each_with_index do |coupled, i|
            if coupled
              coupled_r_idcs << i
              coupled_r_weights << @r_weights[i]
            end
          end

          r_idx = coupled_r_idcs[ALNS.weighted_random_index(rnd, coupled_r_weights)]

          [d_idx, r_idx]
        else
          d_idx = ALNS.weighted_random_index(rnd, @d_weights)
          r_idx = ALNS.weighted_random_index(rnd, @r_weights)
          [d_idx, r_idx]
        end
      end

      def update(candidate, d_idx, r_idx, outcome)
        @d_weights[d_idx] *= @decay
        @d_weights[d_idx] += (1 - @decay) * @scores[outcome]

        @r_weights[r_idx] *= @decay
        @r_weights[r_idx] += (1 - @decay) * @scores[outcome]
      end
    end
  end
end

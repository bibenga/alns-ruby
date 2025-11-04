# frozen_string_literal: true

require 'alns/stop/base'

module ALNS
  module Stop
    class MaxIterations < Base
      def initialize(max_iterations)
        super()
        @max_iterations = max_iterations
        @current_iteration = 0
      end

      def done?(rnd, best, current)
        @current_iteration += 1
        @current_iteration > @max_iterations
      end
    end
  end
end

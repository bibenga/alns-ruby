# frozen_string_literal: true

require 'alns/stop/base'

module ALNS
  module Stop
    class NoImprovement < Base
      def initialize(max_iterations)
        super()
        @max_iterations = max_iterations
        @target = nil
        @counter = 0
      end

      def done?(_rnd, best, _current)
        if @target.nil? || best.objective < @target
          @target = best.objective
          @counter = 0
        else
          @counter += 1
        end
        @counter >= @max_iterations
      end
    end
  end
end

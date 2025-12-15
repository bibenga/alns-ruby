# frozen_string_literal: true

require 'alns/accept/base'

module ALNS
  module Accept
    class GreatDeluge < Base
      def initialize(alpha, beta)
        if alpha <= 1 || !(0 < beta && beta < 1)
          raise ArgumentError, 'alpha must be > 1 and beta must be in (0, 1).'
        end

        @alpha = alpha
        @beta = beta
        @threshold = nil
      end

      def accept?(_rnd, best, _current, candidate)
        @threshold = @alpha * best.objective if @threshold.nil?

        diff = @threshold - candidate.objective

        @threshold -= @beta * diff

        diff.positive?
      end
    end
  end
end

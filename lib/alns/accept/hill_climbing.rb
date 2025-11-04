# frozen_string_literal: true

require 'alns/accept/base'

module ALNS
  module Accept
    class HillClimbing < Base
      def accept?(rnd, best, current, candidate)
        candidate.objective <= current.objective
      end
    end
  end
end

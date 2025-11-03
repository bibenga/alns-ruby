# frozen_string_literal: true

module ALNS
  class Accept
    def accept?(rnd, best, current, candidate)
      raise NotImplementedError
    end
  end

  class HillClimbing < Accept
    def accept?(_rnd, _best, current, candidate)
      candidate.objective <= current.objective
    end
  end
end

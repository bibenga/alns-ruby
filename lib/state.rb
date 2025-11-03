# frozen_string_literal: true

module ALNS
  class State
    def objective
      raise NotImplementedError
    end
  end
end

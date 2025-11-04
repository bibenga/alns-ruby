# frozen_string_literal: true

module ALNS
  module Accept
    class Base
      def accept?(rnd, best, current, candidate)
        raise NotImplementedError
      end
    end
  end
end

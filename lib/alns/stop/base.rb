# frozen_string_literal: true

module ALNS
  module Stop
    class Base
      def done?(rnd, best, current)
        raise NotImplementedError
      end
    end
  end
end

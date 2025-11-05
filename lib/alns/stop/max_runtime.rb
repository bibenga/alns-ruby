# frozen_string_literal: true

require 'alns/stop/base'

module ALNS
  module Stop
    class MaxRuntime < Base
      def initialize(max_runtime)
        super()
        @max_runtime = max_runtime
        @started = nil
      end

      def done?(_rnd, _best, _current)
        if @started.nil?
          @started = Time.new
          return false
        end
        elapsed = Time.now - @started
        elapsed > @max_runtime
      end
    end
  end
end

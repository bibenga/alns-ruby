# frozen_string_literal: true

module ALNS
  module Accept
    module Threshold
      LINEAR = 1
      EXPONENTIAL = 2

      def self.to_s(value)
        case value
        when LINEAR then 'LINEAR'
        when EXPONENTIAL then 'EXPONENTIAL'
        else
          raise ArgumentError, "Invalid method: #{value}"
        end
      end

      def self.update(current, step, method)
        case method
        when LINEAR then current - step
        when EXPONENTIAL then current * step
        else
          raise ArgumentError, "Invalid method: #{value}"
        end
      end
    end
  end
end

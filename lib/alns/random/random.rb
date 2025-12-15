# frozen_string_literal: true

require 'securerandom'

module ALNS
  module Random
    class SecureRandom
      def rand(max = nil)
        if max.nil?
          ::SecureRandom.random_number
        else
          ::SecureRandom.random_number(max)
        end
      end
    end
  end
end

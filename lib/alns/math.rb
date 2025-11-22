# frozen_string_literal: true

module ALNS
  def self.weighted_random_index(rnd, weights)
    raise 'Invalid weights: Array is empty' if weights.empty?
    return 0 if weights.size == 1

    total_sum = weights.sum
    adjusted_value = rnd.rand * total_sum

    weights.each_with_index do |weight, index|
      adjusted_value -= weight

      return index if adjusted_value <= 0
    end

    # we will only be here when errors accumulate
    weights.length - 1
  end
end

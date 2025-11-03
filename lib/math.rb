# frozen_string_literal: true

module ALNS
  EPSILON = 1e-9

  def self.is_close(a, b, epsilon = EPSILON) # rubocop:disable Naming/MethodParameterName
    (a - b).abs <= epsilon
  end

  def self.weighted_random_index(rnd, weights)
    raise 'Invalid weights: Array is empty' if weights.empty?
    return 0 if weights.size == 1

    total_sum = weights.sum
    adjusted_value = rnd.rand * total_sum

    weights.each_with_index do |weight, index|
      adjusted_value -= weight

      return index if adjusted_value <= 0 || is_close(adjusted_value, 0)
    end

    raise "Arithmetic error: sum=#{total_sum}, adjusted_value=#{adjusted_value}, weights=#{weights.inspect}"
  end
end

# frozen_string_literal: true

require_relative 'test_helper'
require 'minitest/autorun'
require 'alns/math'

class MathTest < Minitest::Test
  def setup
    @rng = Random.new(123)
  end

  def test_close
    assert ALNS.close?(1, 1.0000000001)
    assert !ALNS.close?(1, 1.0000001)
  end

  def test_weighted_random_index
    tests = [
      { weights: [1.0], want: 0 }, # one element
      { weights: [0.0, 1.0], want: 1 }, # only the second weight is non-zero
      { weights: [5.0, 0.0, 0.0], want: 0 }, # only the first
      { weights: [0.0, 0.0, 3.0], want: 2 } # only the third
    ]

    tests.each do |tt|
      got = ALNS.weighted_random_index(@rng, tt[:weights])
      assert_equal tt[:want], got, "weights=#{tt[:weights]}: got #{got}, want #{tt[:want]}"
    end
  end

  def test_distribution
    weights = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
    total_runs = 100_000
    counts = Array.new(weights.length, 0)

    total_runs.times do
      idx = ALNS.weighted_random_index(@rng, weights)
      counts[idx] += 1
    end

    sum_of_weights = weights.sum

    allowed_error_percentage = 0.01

    weights.each_with_index do |weight, i|
      expected_count = (weight / sum_of_weights) * total_runs

      got_count = counts[i].to_f

      # ratio = |got - expected| / expected
      error_ratio = (got_count - expected_count).abs / expected_count

      assert_operator error_ratio, :<=, allowed_error_percentage
    end
  end
end

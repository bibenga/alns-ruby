# frozen_string_literal: true

require_relative '../test_helper'
require 'minitest/autorun'
require 'alns/select/roulette_wheel'
require_relative '../models'

class RouletteWheelTest < Minitest::Test
  def setup
    @rnd = Random.new(123)
  end

  def test_select
    select = ALNS::Select::RouletteWheel.new([3, 2, 1, 0.5], 0.8, 3, 2, nil)

    d_counter = [0, 0, 0]
    r_counter = [0, 0]
    total = 10_000

    total.times do
      outcome = @rnd.rand(4)
      d_idx, r_idx = select.select(@rnd, nil, nil)
      select.update(nil, d_idx, r_idx, outcome)
      d_counter[d_idx] += 1
      r_counter[r_idx] += 1
    end

    counters = [d_counter, r_counter]
    counters.each_with_index do |counter, counter_num|
      counter.each_with_index do |got, i|
        expected = 1 / counter.length.to_f * total
        got_f = counter[i].to_f
        error_ratio = (got_f - expected).abs / expected
        assert error_ratio < 0.05,
               "Error at index (#{counter_num}, #{i}): got #{got}, expected ~#{expected} (Error: #{error_ratio.round(2)})"
      end
    end
  end

  def test_select_with_coupling
    select = ALNS::Select::RouletteWheel.new([3, 2, 1, 0.5], 0.8, 2, 3,
                                             [[true, true, false], [false, true, true]])

    d_counter = [0, 0]
    r_counter = [0, 0, 0]
    total = 10_000

    total.times do
      outcome = @rnd.rand(4)
      d_idx, r_idx = select.select(@rnd, nil, nil)
      select.update(nil, d_idx, r_idx, outcome)
      d_counter[d_idx] += 1
      r_counter[r_idx] += 1
    end

    # fifty-fifty
    expected_d_percent = [0.5, 0.5]
    d_counter.each_with_index do |got, i|
      expected = expected_d_percent[i] * total.to_f
      got_f = got.to_f
      error_ratio = (got_f - expected).abs / expected
      assert error_ratio < 0.05,
             "destroy index #{i}: got #{got}, expected ~#{expected.round(2)}"
    end

    expected_r_percent = [0.25, 0.5, 0.25]
    r_counter.each_with_index do |got, i|
      expected = expected_r_percent[i] * total.to_f
      got_f = got.to_f
      error_ratio = (got_f - expected).abs / expected
      assert error_ratio < 0.05,
             "repair index #{i}: got #{got}, expected ~#{expected.round(2)}"
    end
  end
end

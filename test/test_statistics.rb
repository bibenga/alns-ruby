# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/statistics'
require_relative '../lib/outcome'

class StatisticsTest < Minitest::Test
  def test_collect
    stats = ALNS::Statistics.new(2, 2)

    stats.collect_objective(Time.new, 1)
    assert_equal 1, stats.runtimes.length
    assert_equal 1, stats.objectives.length

    stats.collect_objective(Time.new, 2)
    assert_equal 2, stats.runtimes.length
    assert_equal 2, stats.objectives.length

    stats.collect_operators(0, 1, ALNS::Outcome::BEST)
    assert_equal [1, 0, 0, 0], stats.destroy_operator_counts[0]
    assert_equal [1, 0, 0, 0], stats.repair_operator_counts[1]
  end

  def test_freeze
    stats = ALNS::Statistics.new(2, 2)

    stats.collect_objective(Time.new, 1)
    stats.collect_operators(1, 1, ALNS::Outcome::BEST)

    stats.freeze

    assert_raises(FrozenError) do
      stats.collect_objective(Time.new, 2)
    end

    assert_raises(FrozenError) do
      stats.collect_operators(0, 0, ALNS::Outcome::BEST)
    end
  end
end

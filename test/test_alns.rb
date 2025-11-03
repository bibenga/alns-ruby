# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/alns'
require_relative '../lib/state'
require_relative '../lib/select'
require_relative '../lib/accept'
require_relative '../lib/stop'
require_relative '../lib/outcome'

class ALNSTest < Minitest::Test
  def test_alns_dummy
    alns = ALNS::Iterator.new
    refute_nil alns, 'ALNS object was not created successfully (it is nil)'
  end

  def test_alns_iterate_wo_operators
    alns = ALNS::Iterator.new(Random.new(123))

    exception = assert_raises(ArgumentError) do
      alns.iterate nil, nil, nil, nil
    end

    expected_message = 'Missing destroy or repair operators.'
    assert_equal expected_message, exception.message
  end

  def test_iterate
    alns = ALNS::Iterator.new

    initial_solution = DummyState.new(1)
    select = ALNS::RouletteWheel.new([3, 2, 1, 0.5], 0.8, 1, 1)
    accept = ALNS::HillClimbing.new
    stop = ALNS::MaxIterations.new(9)

    alns.add_destroy_operator do |state, _rnd|
      state.dup
    end
    alns.add_repair_operator do |_state, rnd|
      DummyState.new(rnd.rand)
    end
    alns.on_outcome do |outcome, cand|
      # puts "#{Outcome.to_s(outcome)}, #{cand.objective.round(4)}"
      puts format('%-6s %.4f', ALNS::Outcome.to_s(outcome), cand.objective)
    end

    result = alns.iterate initial_solution, select, accept, stop

    pp result
  end
end

class DummyState < ALNS::State
  def initialize(val)
    @objective = val
  end

  attr_reader :objective
end

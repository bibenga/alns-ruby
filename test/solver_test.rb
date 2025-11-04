# frozen_string_literal: true

require_relative 'test_helper'
require 'minitest/autorun'
require 'alns/solver'
require 'alns/accept/hill_climbing'
require 'alns/select/roulette_wheel'
require 'alns/stop/max_iterations'
require_relative 'models'

class SolverTest < Minitest::Test
  def setup
    @rnd = Random.new(123)
    @alns = ALNS::Solver.new(@rnd)
  end

  def test_iterate_wo_operators
    exception = assert_raises(ArgumentError) do
      @alns.iterate nil, nil, nil, nil
    end

    assert_equal 'Missing destroy or repair operators.', exception.message
  end

  def test_iterate
    initial_solution = FakeState.new(1)
    select = ALNS::Select::RouletteWheel.new([3, 2, 1, 0.5], 0.8, 1, 1)
    accept = ALNS::Accept::HillClimbing.new
    stop = ALNS::Stop::MaxIterations.new(9)

    destroy_operator_called = 0
    @alns.add_destroy_operator do |state, _rnd|
      destroy_operator_called += 1
      state.dup
    end

    repair_operator_called = 0
    @alns.add_repair_operator do |_state, rnd|
      repair_operator_called += 1
      FakeState.new(rnd.rand)
    end

    on_outcome_called = 0
    @alns.on_outcome do |_outcome, _cand|
      on_outcome_called += 1
    end

    result = @alns.iterate initial_solution, select, accept, stop
    refute_nil result

    assert_equal 9, on_outcome_called
    assert_equal 9, destroy_operator_called
    assert_equal 9, repair_operator_called
  end
end

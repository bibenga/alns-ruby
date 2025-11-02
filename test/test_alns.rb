require "minitest/autorun"
require_relative "../lib/alns"
require_relative "../lib/state"
require_relative "../lib/select"
require_relative "../lib/accept"
require_relative "../lib/stop"

class ALNSTest < Minitest::Test

  def test_alns_dummy
    alns = ALNS.new
    refute_nil alns, "ALNS object was not created successfully (it is nil)"
  end

  def test_alns_iterate_wo_operators
    alns = ALNS.new(Random.new(123))

    exception = assert_raises(ArgumentError) do
      alns.iterate nil, nil, nil, nil
    end

    expected_message = "Missing destroy or repair operators."
    assert_equal expected_message, exception.message
  end

  def test_iterate
    alns = ALNS.new
    
    initial_solution = DummyState.new(100)
    select = RouletteWheel.new [3, 2, 1, 0.5], 0.8, 1, 1
    accept = HillClimbing.new
    stop = MaxIterations.new 9

    alns.add_destroy_operator(
      ->(state, rnd) { state.dup }
    )
    alns.add_repair_operator(
      ->(state, rnd) { DummyState.new(rnd.rand(100)) }
    )
    alns.listener = lambda do |outcome, cand|
      puts "#{outcome}, #{cand.objective}"
    end

    result = alns.iterate initial_solution, select, accept, stop
  end
end

class DummyState < State
  def initialize(val)
    @objective = val
  end

  def objective
    @objective
  end
end
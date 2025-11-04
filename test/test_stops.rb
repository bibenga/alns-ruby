# frozen_string_literal: true

require_relative 'test_helper'
require 'minitest/autorun'
require 'alns/stop'

class MaxIterationsTest < Minitest::Test
  def test_done?
    stop = ALNS::MaxIterations.new(10)
    exp = 0
    until stop.done?(nil, nil, nil)
      # noop
      exp += 1
    end
    assert_equal 10, exp
  end
end

class MaxRuntimeTest < Minitest::Test
  def test_done?
    stop = ALNS::MaxRuntime.new(0.1)
    started = Time.new
    until stop.done?(nil, nil, nil) # rubocop:disable Style/WhileUntilModifier
      sleep(0.001)
    end
    elapsed = ((Time.new - started) * 1000).to_i
    assert elapsed.between?(100, 105)
  end
end

# frozen_string_literal: true

require_relative '../test_helper'
require 'minitest/autorun'
require 'alns/stop/max_iterations'

class MaxIterationsTest < Minitest::Test
  def test_done?
    stop = ALNS::Stop::MaxIterations.new(10)
    exp = 0
    until stop.done?(nil, nil, nil)
      # noop
      exp += 1
    end
    assert_equal 10, exp
  end
end

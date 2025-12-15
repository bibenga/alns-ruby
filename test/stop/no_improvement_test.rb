# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../models'
require 'minitest/autorun'
require 'alns/stop/no_improvement'

class NoImprovementTest < Minitest::Test
  def test_done?
    stop = ALNS::Stop::NoImprovement.new(2)

    assert !stop.done?(nil, FakeState.new(2), nil)
    assert !stop.done?(nil, FakeState.new(2), nil)
    assert !stop.done?(nil, FakeState.new(1), nil)
    assert !stop.done?(nil, FakeState.new(1), nil)
    assert stop.done?(nil, FakeState.new(1), nil)
  end
end

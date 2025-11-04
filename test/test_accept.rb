# frozen_string_literal: true

require_relative 'test_helper'
require 'minitest/autorun'
require 'alns/accept'
require_relative 'models/state'

class HillClimbingTest < Minitest::Test
  def test_accept?
    accept = ALNS::HillClimbing.new

    best = FakeState.new(2)
    curr = FakeState.new(2.1)
    cand = FakeState.new(1.9)

    assert accept.accept?(nil, best, curr, cand)

    cand = FakeState.new(2.9)
    assert !accept.accept?(nil, best, curr, cand)
  end
end

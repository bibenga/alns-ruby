# frozen_string_literal: true

require_relative '../test_helper'
require 'minitest/autorun'
require 'alns/accept/great_deluge'
require_relative '../fake_state'

class GreatDelugeTest < Minitest::Test
  def test_accept?
    accept = ALNS::Accept::GreatDeluge.new(2, 0.01)

    assert !accept.accept?(nil, Zero, Zero, One)

    assert accept.accept?(nil, Zero, Zero, Zero)

    assert accept.accept?(nil, Zero, Zero, Zero)
  end
end

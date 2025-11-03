# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/state'

class FakeState < ALNS::State
  attr_reader :objective

  def initialize(val)
    super()
    @objective = val
  end
end

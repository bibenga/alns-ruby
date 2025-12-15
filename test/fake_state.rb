# frozen_string_literal: true

require 'alns/state'

class FakeState < ALNS::State
  attr_reader :objective

  def initialize(val)
    super()
    @objective = val
  end
end

Sentinel = FakeState.new(0)
Zero = FakeState.new(0)
One = FakeState.new(1)
Two = FakeState.new(2)

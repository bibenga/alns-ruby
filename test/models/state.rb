# frozen_string_literal: true

require 'minitest/autorun'
require 'alns/state'

class FakeState < ALNS::State
  attr_reader :objective

  def initialize(val)
    super()
    @objective = val
  end
end

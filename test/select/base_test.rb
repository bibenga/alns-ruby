# frozen_string_literal: true

require_relative '../test_helper'
require 'minitest/autorun'
require 'alns/select/base'

class SelectBaseTest < Minitest::Test
  def test_num_validation
    ALNS::Select::Base.new(1, 1, nil)

    exception = assert_raises(ArgumentError) do
      ALNS::Select::Base.new(0, 1, nil)
    end
    assert_equal 'Missing destroy or repair operators.', exception.message

    exception = assert_raises(ArgumentError) do
      ALNS::Select::Base.new(1, 0, nil)
    end
    assert_equal 'Missing destroy or repair operators.', exception.message
  end

  def test_coupling_validation
    ALNS::Select::Base.new(2, 3, [[true, true, true], [true, true, true]])

    exception = assert_raises(ArgumentError) do
      ALNS::Select::Base.new(2, 3, [[true, true], [true]])
    end
    assert_equal 'coupling matrix of shape (2, 2), expected (2, 3)', exception.message

    exception = assert_raises(ArgumentError) do
      ALNS::Select::Base.new(2, 3, [[true, true], [true, true], [true, true]])
    end
    assert_equal 'coupling matrix of shape (3, 2), expected (2, 3)',
                 exception.message

    exception = assert_raises(ArgumentError) do
      ALNS::Select::Base.new(2, 3, [[true, true, true], [true]])
    end
    assert_equal 'the number of columns in a row 1 does not match the expected 3',
                 exception.message

    exception = assert_raises(ArgumentError) do
      ALNS::Select::Base.new(2, 3, [[true, true, true], [false, false, false]])
    end
    assert_equal 'destroy operator 1 has no coupled repair operators',
                 exception.message
  end
end

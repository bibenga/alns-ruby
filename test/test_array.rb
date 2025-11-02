require "minitest/autorun"


class ArrayTest < Minitest::Test

  def test_arr
    destroy_operator_counts = Array.new(3) { [0, 0, 0, 0] }

    destroy_operator_counts[1][2] += 1

    puts destroy_operator_counts
  end

end

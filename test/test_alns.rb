require "minitest/autorun"
require_relative "../lib/alns"

class ALNSTest < Minitest::Test

  def test_alns_init
    alns = ALNS.new
    refute_nil alns, "ALNS object was not created successfully (it is nil)"
  end

end

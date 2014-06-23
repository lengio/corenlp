require "test_helper"

class NumberTest < Minitest::Test
  def test_number_is_initialized_ok
    number = Number.new(text: "1")
    assert number.is_a?(Number)
  end
end

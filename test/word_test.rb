require "test_helper"

class WordTest < Minitest::Test
  def test_word_is_initialized_ok
    word = Word.new(text: "here")
    assert word.is_a?(Word)
  end
end

require "test_helper"

class PunctuationTest < Minitest::Test
  def test_punctuation_is_initialized_ok
    punctuation = Punctuation.new(text: "$")
    assert punctuation.is_a?(Punctuation)
  end

  def test_punctuation_is_currency
    Punctuation::CURRENCY_SYMBOLS.each do |s|
      token = Punctuation.new text: s
      assert token.currency?, "Token #{token.text} should be a currency"
    end

    token = Punctuation.new text: "a"
    assert !token.currency?
  end

  def test_punctuation_is_dash
    Punctuation::DASH_SYMBOLS.each do |s|
      token = Punctuation.new text: s
      assert token.dash?, "Token #{token.text} should be a dash"
    end

    token = Punctuation.new text: "{"
    assert !token.dash?
  end

  def test_punctuation_is_opening
    Punctuation::OPENING_SYMBOLS.each do |s|
      token = Punctuation.new text: s
      assert token.opening?, "Token #{token.text} should be an opening"
    end

    token = Punctuation.new text: "$"
    assert !token.opening?
  end
end

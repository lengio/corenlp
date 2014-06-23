require "test_helper"

class SentenceTest < Minitest::Test
  def test_initialized_ok
    sentence = Sentence.new(index: 0, text: "some text in a sentence.")
    t1 = Token.new(index: 0, text: "some", type: "Word", sentence: sentence)
    t2 = Token.new(index: 1, text: "text", type: "Word", sentence: sentence)
    t3 = Token.new(index: 2, text: "in", type: "Word", sentence: sentence)
    t4 = Token.new(index: 3, text: "a", type: "Word", sentence: sentence)
    td1 = TokenDependency.new(dependent: t1, governor: t2, relation: "det")
    sentence.tokens << t1 << t2 << t3 << t4
    sentence.token_dependencies << td1
    assert_equal 4, sentence.tokens.size
    assert_equal 1, sentence.token_dependencies.size
    assert_equal [td1], sentence.governor_dependencies(t2)
    assert_equal [td1], sentence.token_dependencies
    assert_equal 0, sentence.index
  end

  def test_calculate_previous_and_next_token_from_token_in_a_sentence
    sentence = Sentence.new(index: 0, text: "some text in a sentence.")
    t0 = Word.new(index: 0, text: "some", sentence: sentence)
    t1 = Word.new(index: 1, text: "text", sentence: sentence)
    t2 = Word.new(index: 2, text: "in", sentence: sentence)
    t3 = Word.new(index: 3, text: "a", sentence: sentence)
    sentence.tokens << t0 << t1 << t2 << t3
    assert_equal nil, sentence.previous_token(t0)
    assert_equal nil, sentence.next_token(t3)
    assert_equal t1, sentence.next_token(t0)
    assert_equal t2, sentence.previous_token(t3)
    assert_equal t1, sentence.previous_token(t2)
  end
end

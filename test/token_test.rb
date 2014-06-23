require "test_helper"

class TokenTest < Minitest::Test
  def test_initialized_ok
    assert token = Word.new(index: 0, text: "some", penn_treebank_tag: "NNP",
                      stanford_lemma: "some")
    assert_equal "N", token.top_level_penn_treebank_category
    assert token.content?
  end

  def test_token_equality
    t0 = Word.new(index: 0, text: "some", penn_treebank_tag: "NNP")
    t1 = Word.new(index: 0, text: "more", penn_treebank_tag: "NNP")
    assert t0 == t1
  end

  def test_token_person_ner_value_is_ignored
    assert Token.new(text: "Walter", ner: "PERSON").ignored_entity?
  end

  def test_number_recognition
    text_samples = ["33,333", "20", "30.00", "30,000,000.00"]

    text_samples.each do |text|
      assert_equal Number, Token.token_subclass_from_text(text), text
    end

    text_samples = ["33A333", "20", "30F00", "30X000;000"]
    text_samples.each do |text|
      assert !Token.token_subclass_from_text(text).is_a?(Number)
    end
  end

  def test_enclitic_recognition
    text_samples = %w{n't 'nt 'll n’t ’nt ’ll}

    text_samples.each do |text|
      assert_equal Enclitic, Token.token_subclass_from_text(text)
    end
  end
end

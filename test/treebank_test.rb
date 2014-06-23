require 'test_helper'

class TreebankTest < Minitest::Test
  @@treebank = Treebank.new(raw_text: 'I put the book down on the coffee table.').parse

  def test_treebank_has_all_the_parsed_parts
    # earlier verions of stanford had some different dependencies
    # ["I put nsubj", "the book det", "book put dobj", "down put prt", "on put prep", "the table det", "coffee table nn", "table on pobj"]
    expected = ["I put nsubj", "the book det", "book put dobj", "down put prt", "the table det", "coffee table nn", "table put prep_on"]
    assert_equal expected, @@treebank.sentences.map(&:token_dependencies).flatten.map{|x| "#{x.dependent.text} #{x.governor.text} #{x.relation}"}
  end
end

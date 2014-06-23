require "test_helper"

class EncliticTest < Minitest::Test
  def test_expaneded_returns_the_expanded_version
    enclitic = Enclitic.new(text: "'ll")
    assert_equal "will", enclitic.expanded
  end
end

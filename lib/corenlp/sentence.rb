module Corenlp
  class Sentence
    attr_accessor :index, :tokens, :token_dependencies, :parse_tree_raw

    def initialize(attrs = {})
      self.index = attrs[:index]
      self.tokens = []
      self.token_dependencies = []
      self.parse_tree_raw = ''
    end

    def governor_dependencies(token)
      token_dependencies.select{|td| td.governor == token}
    end

    def next_token(token)
      tokens.sort_by(&:index).detect{|t| t.index > token.index}
    end

    def previous_token(token)
      tokens.sort_by(&:index).reverse.detect{|t| t.index < token.index}
    end

    def get_dependency_token_by_index(index)
      tokens.detect{|t| t.index == index}
    end
  end
end

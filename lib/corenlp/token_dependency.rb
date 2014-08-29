module Corenlp
  class TokenDependency
    attr_accessor :dependent, :governor, :relation

    def initialize(attrs = {})
      self.dependent = attrs[:dependent]
      self.governor = attrs[:governor]
      self.relation = attrs[:relation]
    end
  end
end

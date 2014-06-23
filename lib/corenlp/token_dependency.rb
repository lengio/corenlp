module Corenlp
  class TokenDependency
    attr_accessor :dependent, :governor, :relation

    def initialize(attrs = {})
      @dependent = attrs[:dependent]
      @governor = attrs[:governor]
      @relation = attrs[:relation]
    end
  end
end

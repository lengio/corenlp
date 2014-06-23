module Corenlp
  class Enclitic < Token
    def enclitic_map
      # Note: This isn't really one-to-one (e.g. "'d" could be "had" or "would"):
      {
        "'ll" => "will",
        "'m"  => "am",
        "'re" => "are",
        "'s"  => "is",
        "'d"  => "would",
        "'t"  => "not",
        "'ve" => "have",
        "'nt" => "not",
        "n't" => "not"
      }
    end

    def expanded
      enclitic_map[text]
    end
  end
end

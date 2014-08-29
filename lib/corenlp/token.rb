module Corenlp
  class Token
    attr_accessor :index, :text, :penn_treebank_tag, :stanford_lemma, :type, :ner

    def initialize(attrs = {})
      self.index = attrs[:index]
      self.text = attrs[:text]
      self.penn_treebank_tag = attrs[:penn_treebank_tag]
      self.stanford_lemma = attrs[:stanford_lemma]
      self.type = attrs[:type]
      self.ner = attrs[:ner]
    end

    IGNORED_ENTITIES = ["PERSON"]

    def content?
      is_a?(Word) || is_a?(Enclitic)
    end

    def top_level_penn_treebank_category
      penn_treebank_tag[0]
    end

    def ==(other)
      index == other.index && \
        penn_treebank_tag == other.penn_treebank_tag && type == other.type
    end

    def website_text?
      text =~ /http:\/\//
    end

    def self.clean_stanford_text(text)
      Token::STANFORD_TEXT_REPLACEMENTS.each_pair do |original, replacement|
        text.gsub!(replacement, original)
      end
      text
    end

    Enclitics = %w{'ll 'm 're 's 't 've 'nt n't 'd ’ll ’m ’re ’s ’t ’ve ’nt n’t ’d}
    WordRegexp = /^[[:alpha:]\-'\/]+$/
    NumberRegexp = /^#?(\d+)(,\d+)*(\.\d+)?$/
    PunctRegexp = /^[[:punct:]'"\$]+$/
    WebsiteRegexp = /https?:\/\/[\S]+/

    # The character replacements that Stanford performs which we reverse:
    STANFORD_TEXT_REPLACEMENTS = {
      '”' => "''",    '“' => '``',    '(' => '-LRB-',
      ')' => '-RRB-', '[' => '-LSB-', ']' => '-RSB-',
      '{' => '-LCB-', '}' => '-RCB-',
      '‘' => '`', '’' => '\'', '—' => '--', '/' => '\\/'
    }

    def ignored_entity?
      IGNORED_ENTITIES.include?(self.ner)
    end

    def self.token_subclass_from_text(text)
      case
      when Enclitics.include?(text)
        Enclitic
      when (text =~ WordRegexp && text != '-') || (text =~ WebsiteRegexp)
        Word
      when text =~ PunctRegexp
        Punctuation
      when text =~ NumberRegexp
        Number
      else
        Token
      end
    end
  end
end

module Corenlp
  class Punctuation < Token
    # From http://www.unicode.org/charts/PDF/U20A0.pdf
    CURRENCY_SYMBOLS = %W(\u0024 \u00A2 \u00A3 \u00A4 \u00A5 \u20AC)
    DASH_SYMBOLS = %W(\u2010 \u2011 \u2012 \u2013 \u2014)
    OPENING_SYMBOLS = %W(\u201C \u2018 \u00A1 \u00BF \( [ {)

    def currency?
      CURRENCY_SYMBOLS.include?(text)
    end

    def dash?
      DASH_SYMBOLS.include?(text)
    end

    def opening?
      OPENING_SYMBOLS.include?(text)
    end
  end
end

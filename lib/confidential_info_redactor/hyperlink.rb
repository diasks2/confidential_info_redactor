require 'uri'

module ConfidentialInfoRedactor
  class Hyperlink
    NON_HYPERLINK_REGEX = /\A\w+:$/

    # Rubular: http://rubular.com/r/fXa4lp0gfS
    HYPERLINK_REGEX = /(http|https|www)(\.|:)/

    def hyperlink?(text)
      !(text !~ URI.regexp) && text !~ NON_HYPERLINK_REGEX && !(text !~ HYPERLINK_REGEX)
    end

    def replace(text)
      text.split(/\s+/).map { |token| text = text.gsub(/#{Regexp.escape(token.gsub(/\.\z/, ''))}/, ' <redacted> ') if !(token !~ HYPERLINK_REGEX) }
      text
    end
  end
end

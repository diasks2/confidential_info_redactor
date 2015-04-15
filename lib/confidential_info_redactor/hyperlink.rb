require 'uri'

module ConfidentialInfoRedactor
  class Hyperlink
    NON_HYPERLINK_REGEX = /\A\w+:$/

    # Rubular: http://rubular.com/r/fXa4lp0gfS
    HYPERLINK_REGEX = /(http|https|www)(\.|:)/

    attr_reader :string
    def initialize(string:)
      @string = string
    end

    def hyperlink?
      !(string !~ URI.regexp) && string !~ NON_HYPERLINK_REGEX && !(string !~ HYPERLINK_REGEX)
    end

    def replace
      new_string = string.dup
      string.split(/\s+/).each do |token|
        if !(token !~ URI.regexp) && token !~ NON_HYPERLINK_REGEX && !(token !~ HYPERLINK_REGEX) && token.include?('">')
          new_string = new_string.gsub(/#{Regexp.escape(token.split('">')[0])}/, ' <redacted> ')
        elsif !(token !~ URI.regexp) && token !~ NON_HYPERLINK_REGEX && !(token !~ HYPERLINK_REGEX)
          new_string = new_string.gsub(/#{Regexp.escape(token)}/, ' <redacted> ')
        end
      end
      new_string
    end
  end
end

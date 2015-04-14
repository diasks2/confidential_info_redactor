require 'confidential_info_redactor/date'

module ConfidentialInfoRedactor
  # This class redacts various tokens from a text
  class Redactor
    # Rubular: http://rubular.com/r/aGqvObk6SL
    NUMBER_REGEX = /(?<=\A)\D?\d+((,|\.)*\d)*(\D?\s|\s|\.?\s|\.$)|(?<=\s)\D?\d+((,|\.)*\d)*(?=(\D?\s|\s|\.?\s|\.$))/
    attr_reader :text, :language, :corpus
    def initialize(text:, **args)
      @text = text
      @language = args[:language] || 'en'
      case @language
      when 'en'
        @corpus = ConfidentialInfoRedactor::WordLists::EN_WORDS
      when 'de'
        @corpus = ConfidentialInfoRedactor::WordLists::DE_WORDS
      end
    end

    def dates
      ConfidentialInfoRedactor::Date.new(string: text).replace.gsub(/\s*wsdateword\s*/, " <redacted date> ").gsub(/\A\s*<redacted date>\s*/, "<redacted date> ").gsub(/<redacted date>\s{1}\.{1}/, "<redacted date>.")
    end

    def numbers
      text.gsub(NUMBER_REGEX, ' <redacted number> ').gsub(/\s*<redacted number>\s*/, " <redacted number> ").gsub(/\A\s*<redacted number>\s*/, "<redacted number> ").gsub(/<redacted number>\s{1}\.{1}/, "<redacted number>.")
    end

    def tokens

    end
  end
end

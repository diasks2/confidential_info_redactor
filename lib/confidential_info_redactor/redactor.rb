require 'confidential_info_redactor/date'

module ConfidentialInfoRedactor
  # This class redacts various tokens from a text
  class Redactor
    # Rubular: http://rubular.com/r/LRRPtDgJOe
    NUMBER_REGEX = /(?<=\A|\A\()[^(]?\d+((,|\.)*\d)*(\D?\s|\s|\.?\s|\.$)|(?<=\s|\s\()[^(]?\d+((,|\.)*\d)*(?=(\D?\s|\s|\.?\s|\.$))|(?<=\s)\d+(nd|th|st)|(?<=\s)\d+\/\d+\"*(?=\s)/
    attr_reader :text, :language, :corpus, :number_text, :date_text, :token_text, :tokens
    def initialize(text:, **args)
      @text = text
      @language = args[:language] || 'en'
      @tokens = args[:tokens]
      @number_text = args[:number_text] || '<redacted number>'
      @date_text = args[:date_text] || '<redacted date>'
      @token_text = args[:token_text] || '<redacted>'
      case @language
      when 'en'
        @corpus = ConfidentialInfoRedactor::WordLists::EN_WORDS
      when 'de'
        @corpus = ConfidentialInfoRedactor::WordLists::DE_WORDS
      end
    end

    def dates
      redact_dates(text)
    end

    def numbers
      redact_numbers(text)
    end

    def proper_nouns
      redact_tokens(text)
    end

    def redact
      redacted_text = redact_dates(text)
      redacted_text = redact_numbers(redacted_text)
      redact_tokens(redacted_text)
    end

    private

    def redact_dates(txt)
      ConfidentialInfoRedactor::Date.new(string: txt).replace.gsub(/\s*#{Regexp.escape(date_text)}\s*/, " #{date_text} ").gsub(/\A\s*#{Regexp.escape(date_text)}\s*/, "#{date_text} ").gsub(/#{Regexp.escape(date_text)}\s{1}\.{1}/, "#{date_text}.")
    end

    def redact_numbers(txt)
      txt.gsub(NUMBER_REGEX, " #{number_text} ").gsub(/\s*#{Regexp.escape(number_text)}\s*/, " #{number_text} ").gsub(/\A\s*#{Regexp.escape(number_text)}\s*/, "#{number_text} ").gsub(/#{Regexp.escape(number_text)}\s{1}\.{1}/, "#{number_text}.").gsub(/#{Regexp.escape(number_text)}\s{1}\,{1}/, "#{number_text},").gsub(/#{Regexp.escape(number_text)}\s{1}\){1}/, "#{number_text})").gsub(/\(\s{1}#{Regexp.escape(number_text)}/, "(#{number_text}")
    end

    def redact_tokens(txt)
      tokens.sort_by{ |x| x.split.count }.reverse.each do |token|
        txt.gsub!(/#{Regexp.escape(token)}/, "#{token_text}")
      end
      txt
    end
  end
end

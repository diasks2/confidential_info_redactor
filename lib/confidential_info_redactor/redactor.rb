require 'confidential_info_redactor/date'
require 'confidential_info_redactor/hyperlink'

module ConfidentialInfoRedactor
  # This class redacts various tokens from a text
  class Redactor
    # Rubular: http://rubular.com/r/LRRPtDgJOe
    NUMBER_REGEX = /(?<=\A|\A\()[^(]?\d+((,|\.)*\d)*(\D?\s|\s|\.?\s|\.$)|(?<=\s|\s\()[^(]?\d+((,|\.)*\d)*(?=(\D?\s|\s|\.?\s|\.$))|(?<=\s)\d+(nd|th|st)|(?<=\s)\d+\/\d+\"*(?=\s)/
    EMAIL_REGEX = /(?<=\A|\s)[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+(?=\z|\s|\.)/i


    attr_reader :text, :language, :number_text, :date_text, :token_text, :tokens, :ignore_emails, :ignore_dates, :ignore_numbers, :ignore_hyperlinks
    def initialize(text:, **args)
      @text = text
      @language = args[:language] || 'en'
      @tokens = args[:tokens]
      @number_text = args[:number_text] || '<redacted number>'
      @date_text = args[:date_text] || '<redacted date>'
      @token_text = args[:token_text] || '<redacted>'
      @ignore_emails = args[:ignore_emails]
      @ignore_dates = args[:ignore_dates]
      @ignore_numbers = args[:ignore_numbers]
      @ignore_hyperlinks = args[:ignore_hyperlinks]
    end

    def dates
      redact_dates(text)
    end

    def numbers
      redact_numbers(text)
    end

    def emails
      redact_emails(text)
    end

    def hyperlinks
      redact_hyperlinks(text)
    end

    def proper_nouns
      redact_tokens(text)
    end

    def redact
      if ignore_emails
        redacted_text = text
      else
        redacted_text = redact_emails(text)
      end
      redacted_text = redact_hyperlinks(redacted_text) unless ignore_hyperlinks
      redacted_text = redact_dates(redacted_text) unless ignore_dates
      redacted_text = redact_numbers(redacted_text) unless ignore_numbers
      redact_tokens(redacted_text)
    end

    private

    def redact_hyperlinks(txt)
      ConfidentialInfoRedactor::Hyperlink.new(string: txt).replace.gsub(/<redacted>/, "#{token_text}").gsub(/\s*#{Regexp.escape(token_text)}\s*/, " #{token_text} ").gsub(/#{Regexp.escape(token_text)}\s{1}\.{1}/, "#{token_text}.").gsub(/#{Regexp.escape(token_text)}\s{1}\,{1}/, "#{token_text},")
    end

    def redact_dates(txt)
      ConfidentialInfoRedactor::Date.new(string: txt, language: language).replace.gsub(/<redacted date>/, "#{date_text}").gsub(/\s*#{Regexp.escape(date_text)}\s*/, " #{date_text} ").gsub(/\A\s*#{Regexp.escape(date_text)}\s*/, "#{date_text} ").gsub(/#{Regexp.escape(date_text)}\s{1}\.{1}/, "#{date_text}.")
    end

    def redact_numbers(txt)
      txt.gsub(NUMBER_REGEX, " #{number_text} ").gsub(/\s*#{Regexp.escape(number_text)}\s*/, " #{number_text} ").gsub(/\A\s*#{Regexp.escape(number_text)}\s*/, "#{number_text} ").gsub(/#{Regexp.escape(number_text)}\s{1}\.{1}/, "#{number_text}.").gsub(/#{Regexp.escape(number_text)}\s{1}\,{1}/, "#{number_text},").gsub(/#{Regexp.escape(number_text)}\s{1}\){1}/, "#{number_text})").gsub(/\(\s{1}#{Regexp.escape(number_text)}/, "(#{number_text}")
    end

    def redact_emails(txt)
      txt.gsub(EMAIL_REGEX, "#{token_text}")
    end

    def redact_tokens(txt)
      tokens.sort_by{ |x| x.split.count }.reverse.each do |token|
        txt.gsub!(/#{Regexp.escape(token)}/, "#{token_text}")
      end
      txt
    end
  end
end

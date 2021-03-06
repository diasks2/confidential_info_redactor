require 'confidential_info_redactor/date'
require 'confidential_info_redactor/hyperlink'

module ConfidentialInfoRedactor
  # This class redacts various tokens from a text
  class Redactor
    # Rubular: http://rubular.com/r/OI2wQZ0KSl
    NUMBER_REGEX = /(?<=\A|\A\()[^(]?\d+((,|\.|\/)*\d)*(\D?\s|\s|[[:cntrl:]]|[[:space:]]|\.?\s|\.$|$)|(?<=[[:cntrl:]]|[[:space:]]|\s|\s\(|\s'|\s‘)[^('‘]?\d+((,|\.|\/)*\d)*\"*(?=(\D?\s|\s|[[:cntrl:]]|[[:space:]]|\.?\s|\.$|$))|(?<=\s)\d+(nd|th|st)|(?<=\s)\d+\/\d+\"*(?=\s)|(?<=\()\S{1}\d+(?=\))|(?<=\s{1})\S{1}\d+\z|^\d+$|(?<=\A|\A\(|\s|[[:cntrl:]]|[[:space:]]|\s\()[^(]?\d+((,|\.|\/)*\d)*\D{2}(?=($|\s+))|(?<=\A|[[:cntrl:]]|[[:space:]]|\s|\A\(|\s\()[^\(\s]*\d+[^\.\s\)]*(?=\z|$|\s|\.$|\.\s|\))/

    # Rubular: http://rubular.com/r/mxcj2G0Jfa
    EMAIL_REGEX = /(?<=\A|\s|\()[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+(?=\z|\s|\.|\))/i

    attr_reader :language, :number_text, :date_text, :token_text, :tokens, :ignore_emails, :ignore_dates, :ignore_numbers, :ignore_hyperlinks
    def initialize(**args)
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

    def dates(text)
      redact_dates(text)
    end

    def numbers(text)
      redact_numbers(text)
    end

    def emails(text)
      redact_emails(text)
    end

    def hyperlinks(text)
      redact_hyperlinks(text)
    end

    def proper_nouns(text)
      redact_tokens(text)
    end

    def redact(text)
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
      ConfidentialInfoRedactor::Hyperlink.new.replace(txt).gsub(/<redacted>/, "#{token_text}").gsub(/\s*#{Regexp.escape(token_text)}\s*/, " #{token_text} ").gsub(/#{Regexp.escape(token_text)}\s{1}\.{1}/, "#{token_text}.").gsub(/#{Regexp.escape(token_text)}\s{1}\,{1}/, "#{token_text},")
    end

    def redact_dates(txt)
      ConfidentialInfoRedactor::Date.new(language: language).replace(txt).gsub(/<redacted date>/, "#{date_text}").gsub(/\s*#{Regexp.escape(date_text)}\s*/, " #{date_text} ").gsub(/\A\s*#{Regexp.escape(date_text)}\s*/, "#{date_text} ").gsub(/#{Regexp.escape(date_text)}\s{1}\.{1}/, "#{date_text}.")
    end

    def redact_numbers(txt)
      txt.gsub(NUMBER_REGEX, " #{number_text} ").gsub(/\s*#{Regexp.escape(number_text)}\s*/, " #{number_text} ").gsub(/\A\s*#{Regexp.escape(number_text)}\s*/, "#{number_text} ").gsub(/#{Regexp.escape(number_text)}\s{1}\.{1}/, "#{number_text}.").gsub(/#{Regexp.escape(number_text)}\s{1}\,{1}/, "#{number_text},").gsub(/#{Regexp.escape(number_text)}\s{1}\){1}/, "#{number_text})").gsub(/\(\s{1}#{Regexp.escape(number_text)}/, "(#{number_text}").gsub(/#{Regexp.escape(number_text)}\s\z/, "#{number_text}")
    end

    def redact_emails(txt)
      txt.gsub(EMAIL_REGEX, "#{token_text}")
    end

    def redact_tokens(txt)
      tokens.sort_by{ |x| x.split.count }.reverse.each do |token|
        txt.gsub!(/(?<=\s|^|\")#{Regexp.escape(token)}(?=\W|$)/, "#{token_text}")
      end
      txt.strip
    end
  end
end

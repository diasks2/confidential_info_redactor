require 'confidential_info_redactor/word_lists'

module ConfidentialInfoRedactor
  # This class extracts proper nouns from a text
  class Extractor
    # Rubular: http://rubular.com/r/BrA6twGdaA
    EXTRACT_REGEX = /((?<=\s)|(?<=^))[A-Z]\S*\s[A-Z]\S*\s[A-Z]\S*\s[A-Z]\S*(?=(\s|\.))|((?<=\s)|(?<=^))[A-Z]\S*\s[A-Z]\S*\s[A-Z]\S*(?=(\s|\.))|((?<=\s)|(?<=^))[A-Z]\S*\s[A-Z]\S*(?=(\s|\.))|((?<=\s)|(?<=^))[A-Z]\S*(?=(\s|\.))/
    attr_reader :text, :language, :corpus
    def initialize(text:, **args)
      @text = text.gsub(/’/, "'")
      @language = args[:language] || 'en'
      case @language
      when 'en'
        @corpus = ConfidentialInfoRedactor::WordLists::EN_WORDS
      when 'de'
        @corpus = ConfidentialInfoRedactor::WordLists::DE_WORDS
      end
    end

    def extract
      initial_extracted_terms = text.gsub(EXTRACT_REGEX).map { |match| match unless corpus.include?(match.downcase.gsub(/[\?\.\)\(\!\\\/\"\:\;]/, '').gsub(/\'$/, '')) }.compact
      extracted_terms = []
      initial_extracted_terms.each do |ngram|
        ngram.split(/[\?\.\)\(\!\\\/\"\:\;\,]/).each do |t|
          extracted_terms << t.gsub(/[\?\.\)\(\!\\\/\"\:\;\,]/, '').gsub(/\'$/, '').strip unless corpus.include?(t.downcase.gsub(/[\?\.\)\(\!\\\/\"\:\;]/, '').gsub(/\'$/, '').strip)
        end
      end

      if language.eql?('de')
        extracted_terms.delete_if do |token|
          corpus.include?(token.split(' ')[0].downcase.strip) &&
            token.split(' ')[0].downcase.strip != 'deutsche'
        end.uniq
      else
        extracted_terms.uniq
      end
    end
  end
end

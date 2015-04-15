require 'confidential_info_redactor/word_lists'

module ConfidentialInfoRedactor
  # This class extracts proper nouns from a text
  class Extractor
    # Rubular: http://rubular.com/r/qE0g4r9zR7
    EXTRACT_REGEX = /(?<=\s|^|\s\")([A-Z]\S*\s)*[A-Z]\S*(?=(\s|\.|\z))|(?<=\s|^|\s\")[i][A-Z][a-z]+/
    attr_reader :text, :language, :corpus
    def initialize(text:, **args)
      @text = text.gsub(/[’‘]/, "'")
      @language = args[:language] || 'en'
      case @language
      when 'en'
        @corpus = ConfidentialInfoRedactor::WordLists::EN_WORDS
      when 'de'
        @corpus = ConfidentialInfoRedactor::WordLists::DE_WORDS
      else
        @corpus = ConfidentialInfoRedactor::WordLists::EN_WORDS
      end
    end

    def extract
      extracted_terms = []
      PragmaticSegmenter::Segmenter.new(text: text, language: language).segment.each do |segment|
        initial_extracted_terms = segment.gsub(EXTRACT_REGEX).map { |match| match unless corpus.include?(match.downcase.gsub(/[\?\.\)\(\!\\\/\"\:\;]/, '').gsub(/\'$/, '')) }.compact
        initial_extracted_terms.each do |ngram|
          ngram.split(/[\?\)\(\!\\\/\"\:\;\,]/).each do |t|
            extracted_terms << t.gsub(/[\?\)\(\!\\\/\"\:\;\,]/, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip unless corpus.include?(t.downcase.gsub(/[\?\.\)\(\!\\\/\"\:\;]/, '').gsub(/\'$/, '').strip)
          end
        end
      end

      if language.eql?('de')
        extracted_terms.delete_if do |token|
          corpus.include?(token.split(' ')[0].downcase.strip) &&
            token.split(' ')[0].downcase.strip != 'deutsche'
        end.uniq.reject(&:empty?)
      else
        extracted_terms.uniq.reject(&:empty?)
      end
    end
  end
end

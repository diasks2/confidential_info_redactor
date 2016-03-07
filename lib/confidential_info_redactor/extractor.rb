require 'confidential_info_redactor/word_lists'

module ConfidentialInfoRedactor
  # This class extracts proper nouns from a text
  class Extractor
    # Rubular: http://rubular.com/r/qE0g4r9zR7
    EXTRACT_REGEX = /(?<=\s|^|\s\"|\s\“|\s\«|\s\‹|\s\”|\s\»|\s\›)([A-Z]\S*\s)*[A-Z]\S*(?=(\s|\.|\z))|(?<=\s|^|\s\"|\s\”|\s\»|\s\›|\s\“|\s\«|\s\‹)[i][A-Z][a-z]+/

    PUNCTUATION_REGEX = /[\?\)\(\!\\\/\"\:\;\,\”\“\«\»\‹\›]/

    attr_reader :language, :corpus
    def initialize(**args)
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

    def extract(text)
      extracted_terms = []
      PragmaticSegmenter::Segmenter.new(text: text.gsub(/[’‘]/, "'"), language: language).segment.each do |segment|
        initial_extracted_terms = extract_preliminary_terms(segment)
        search_ngrams(initial_extracted_terms, extracted_terms)
      end
      extracted_terms.map { |t| t.gsub(/\{\}/, '') }.delete_if { |t| t.length == 1 }.uniq.reject(&:empty?)
    end

    private

    def extract_preliminary_terms(segment)
      segment.to_s.gsub(EXTRACT_REGEX).map { |match| match unless corpus.include?(match.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '')) }.compact
    end

    def clean_token(token)
      token.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip
    end

    def non_confidential_token?(token, includes_confidential)
      corpus.include?(token) || !includes_confidential || singular_in_corpus?(token)
    end

    def singular_in_corpus?(token)
      corpus.include?(token[0...-1]) &&
        token[-1].eql?('s') ||
        corpus.include?(token[0...-2]) && token[-2..-1].eql?('en') ||
        corpus.include?(token[0...-2]) && token[-2..-1].eql?('es') ||
        corpus.include?(token[0...-2]) && token[-2..-1].eql?('er') ||
        corpus.include?(token[0...-1]) && token[-1].eql?('n')
    end

    def includes_confidential?(token)
      token.split(' ').map { |t| return false if corpus.include?(t.downcase) } unless token.split(' ').length.eql?(2) && token.split(' ')[1].downcase.eql?('bank')
      true
    end

    def matching_first_token?(tokens)
      corpus.include?(tokens[0]) &&
        tokens[0] != 'the' &&
        tokens[0] != 'deutsche' &&
        tokens.length.eql?(2)
    end

    def find_extracted_terms(string, extracted_terms)
      cleaned_token_downcased = clean_token(string.downcase)
      cleaned_token = clean_token(string)
      tokens = cleaned_token_downcased.split(' ')
      if matching_first_token?(tokens)
        extracted_terms << cleaned_token.split(' ')[1] unless corpus.include?(tokens[1])
      else
        extracted_terms << cleaned_token unless non_confidential_token?(cleaned_token_downcased, includes_confidential?(cleaned_token))
      end
      extracted_terms
    end

    def search_ngrams(tokens, extracted_terms)
      tokens.each do |ngram|
        ngram.split(PUNCTUATION_REGEX).each do |t|
          next if !(t !~ /.*\d+.*/)
          extracted_terms = find_extracted_terms(t, extracted_terms)
        end
      end
    end
  end
end

require 'spec_helper'

RSpec.describe ConfidentialInfoRedactor::Extractor do
  describe '#extract' do
    context 'English (en)' do
      it 'extracts the proper nouns from a text #001' do
        text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000.'
        expect(described_class.new(text: text, language: 'en').extract).to eq(['Coca-Cola', 'Pepsi'])
      end

      it 'extracts the proper nouns from a text #002' do
        text = 'Coca-Cola announced a merger with Pepsi.'
        expect(described_class.new(text: text, language: 'en').extract).to eq(['Coca-Cola', 'Pepsi'])
      end

      it 'extracts the proper nouns from a text #003' do
        text = 'Many employees of Deutsche Bank are looking for another job.'
        expect(described_class.new(text: text, language: 'en').extract).to eq(['Deutsche Bank'])
      end

      it 'extracts the proper nouns from a text #004' do
        text = 'Many employees of Deutsche Bank are looking for another job while those from Pepsi are not.'
        expect(described_class.new(text: text, language: 'en').extract).to eq(['Deutsche Bank', 'Pepsi'])
      end
    end

    context 'German (de)' do
      it 'extracts the proper nouns from a text #001' do
        text = 'Viele Mitarbeiter der Deutschen Bank suchen eine andere Arbeitsstelle.'
        expect(described_class.new(text: text, language: 'de').extract).to eq(['Deutschen Bank'])
      end

      it 'extracts the proper nouns from a text #001' do
        text = 'Viele Mitarbeiter der Deutsche Bank suchen eine andere Arbeitsstelle.'
        expect(described_class.new(text: text, language: 'de').extract).to eq(['Deutsche Bank'])
      end
    end
  end
end
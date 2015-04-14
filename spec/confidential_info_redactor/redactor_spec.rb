require 'spec_helper'

RSpec.describe ConfidentialInfoRedactor::Redactor do
  describe '#dates' do
    it 'extracts dates from a text #001' do
      text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000.'
      expect(described_class.new(text: text, language: 'en').dates).to eq('Coca-Cola announced a merger with Pepsi that will happen on <redacted date> for $200,000,000,000.')
    end

    it 'extracts dates from a text #002' do
      text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020.'
      expect(described_class.new(text: text, language: 'en').dates).to eq('Coca-Cola announced a merger with Pepsi that will happen on <redacted date>.')
    end

    it 'extracts dates from a text #003' do
      text = 'December 5, 2010 - Coca-Cola announced a merger with Pepsi.'
      expect(described_class.new(text: text, language: 'en').dates).to eq('<redacted date> - Coca-Cola announced a merger with Pepsi.')
    end
  end

  describe '#numbers' do
    it 'extracts numbers from a text #001' do
      text = 'Coca-Cola announced a merger with Pepsi that will happen on <redacted date> for $200,000,000,000.'
      expect(described_class.new(text: text, language: 'en').numbers).to eq('Coca-Cola announced a merger with Pepsi that will happen on <redacted date> for <redacted number>.')
    end

    it 'extracts numbers from a text #002' do
      text = '200 years ago.'
      expect(described_class.new(text: text, language: 'en').numbers).to eq('<redacted number> years ago.')
    end
  end
end
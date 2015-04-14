require 'spec_helper'

RSpec.describe ConfidentialInfoRedactor::Redactor do
  describe '#dates' do
    it 'redacts dates from a text #001' do
      text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000.'
      expect(described_class.new(text: text, language: 'en').dates).to eq('Coca-Cola announced a merger with Pepsi that will happen on <redacted date> for $200,000,000,000.')
    end

    it 'redacts dates from a text #002' do
      text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020.'
      expect(described_class.new(text: text, language: 'en').dates).to eq('Coca-Cola announced a merger with Pepsi that will happen on <redacted date>.')
    end

    it 'redacts dates from a text #003' do
      text = 'December 5, 2010 - Coca-Cola announced a merger with Pepsi.'
      expect(described_class.new(text: text, language: 'en').dates).to eq('<redacted date> - Coca-Cola announced a merger with Pepsi.')
    end
  end

  describe '#numbers' do
    it 'redacts numbers from a text #001' do
      text = 'Coca-Cola announced a merger with Pepsi that will happen on <redacted date> for $200,000,000,000.'
      expect(described_class.new(text: text, language: 'en').numbers).to eq('Coca-Cola announced a merger with Pepsi that will happen on <redacted date> for <redacted number>.')
    end

    it 'redacts numbers from a text #002' do
      text = '200 years ago.'
      expect(described_class.new(text: text, language: 'en').numbers).to eq('<redacted number> years ago.')
    end
  end

  describe '#proper_nouns' do
    it 'redacts tokens from a text #001' do
      tokens = ['Coca-Cola', 'Pepsi']
      text = 'Coca-Cola announced a merger with Pepsi that will happen on on December 15th, 2020 for $200,000,000,000.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens).proper_nouns).to eq('<redacted> announced a merger with <redacted> that will happen on on December 15th, 2020 for $200,000,000,000.')
    end

    it 'redacts tokens from a text #002' do
      tokens = ['Coca-Cola', 'Pepsi']
      text = 'Coca-Cola announced a merger with Pepsi that will happen on on December 15th, 2020 for $200,000,000,000.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens, token_text: '*****').proper_nouns).to eq('***** announced a merger with ***** that will happen on on December 15th, 2020 for $200,000,000,000.')
    end
  end

  describe '#redact' do
    it 'redacts all confidential information from a text #001' do
      tokens = ['Coca-Cola', 'Pepsi']
      text = 'Coca-Cola announced a merger with Pepsi that will happen on on December 15th, 2020 for $200,000,000,000.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens).redact).to eq('<redacted> announced a merger with <redacted> that will happen on on <redacted date> for <redacted number>.')
    end
  end
end
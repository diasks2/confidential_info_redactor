require 'spec_helper'

RSpec.describe ConfidentialInfoRedactor::Date do
  context '#includes_date?' do
    it 'returns true if the string includes a date #001' do
      string = 'Today is Monday, April 4th, 2011, aka 04/04/2011.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #002' do
      string = 'Today is Monday April 4th 2011.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #003' do
      string = 'Today is April 4th, 2011.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #004' do
      string = 'Today is Mon., Apr. 4, 2011.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #005' do
      string = 'Today is 04/04/2011.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #006' do
      string = 'Today is 04.04.2011.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #007' do
      string = 'Today is 2011.04.04.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #008' do
      string = 'Today is 2011/04/04.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #009' do
      string = 'Today is 2011-04-04.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #010' do
      string = 'Today is 04-04-2011.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #011' do
      string = 'Today is 2003 November 9.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #012' do
      string = 'Today is 2003Nov9.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #013' do
      string = 'Today is 2003Nov09.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #014' do
      string = 'Today is 2003-Nov-9.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #015' do
      string = 'Today is 2003-Nov-09.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #016' do
      string = 'Today is 2003-Nov-9, Sunday.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #017' do
      string = 'Today is 2003. november 9.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #018' do
      string = 'Today is 2003.11.9.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #019' do
      string = 'Today is Monday, Apr. 4, 2011.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #020' do
      string = 'Today is 2003/11/09.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #021' do
      string = 'Today is 20030109.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #022' do
      string = 'Today is 01092003.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #023' do
      string = 'Today is Sunday, November 9, 2014.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #024' do
      string = 'Today is November 9, 2014.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #025' do
      string = 'Today is Nov. 9, 2014.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #026' do
      string = 'Today is july 1st.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #027' do
      string = 'Today is jul. 1st.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #028' do
      string = 'Today is 8 November 2014.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #029' do
      string = 'Today is 8. November 2014.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #030' do
      string = 'Today is 08-Nov-2014.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #031' do
      string = 'Today is 08Nov14.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #032' do
      string = 'Today is 8th November 2014.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #033' do
      string = 'Today is the 8th of November 2014.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #034' do
      string = 'Today is 08/Nov/2014.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #035' do
      string = 'Today is Sunday, 8 November 2014.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns true if the string includes a date #036' do
      string = 'Today is 8 November 2014.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(true)
    end

    it 'returns false if the string does not include a date #037' do
      string = 'Hello world. There is no date here - $50,000. The sun is hot.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.includes_date?).to eq(false)
    end
  end

  context '#occurences' do
    it 'counts the date occurences in a string #001' do
      string = 'Today is Sunday, 8 November 2014.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.occurences).to eq(1)
    end

    it 'counts the date occurences in a string #002' do
      string = 'Today is Sunday, 8 November 2014. Yesterday was 07/Nov/2014.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.occurences).to eq(2)
    end
  end

  context '#replace' do
    it 'replaces the date occurences in a string #001' do
      string = 'Today is Tues. March 3rd, 2011.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.replace).to eq('Today is  <redacted date> .')
    end

    it 'replaces the date occurences in a string #002' do
      string = 'The scavenger hunt ends on Dec. 31st, 2011.'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.replace).to eq('The scavenger hunt ends on  <redacted date> .')
    end
  end

  context '#replace_number_only_date' do
    it 'replaces only the number date occurences in a string' do
      string = 'Today is Tues. March 3rd, 2011. 4/28/2013'
      ws = ConfidentialInfoRedactor::Date.new(string: string)
      expect(ws.replace_number_only_date).to eq("Today is Tues. March 3rd, 2011.  <redacted date> ")
    end
  end
end

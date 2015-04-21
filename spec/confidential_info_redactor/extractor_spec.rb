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

      it 'extracts the proper nouns from a text #005' do
        text = 'There are many employees at Deutsche Bank. Some are thinking about drinking Pepsi, Coke, or Sprite.'
        expect(described_class.new(text: text, language: 'en').extract).to eq(['Deutsche Bank', 'Pepsi', 'Coke', 'Sprite'])
      end

      it 'extracts the proper nouns from a text #006' do
        text = <<-EOF
          Putter King Miniature Golf Scavenger Hunt

          Putter King is hosting the 1st Annual Miniature Golf Scavenger Hunt.  So get out your putter and your camera and see if you have what it takes.  Are you a King?

          The Official List:

          #1) Autographs of 2 professional miniature golfers, each from a different country. (45 points; 5 bonus points if the professional miniature golfers are also from 2 different continents)

          #2) Picture of yourself next to each obstacle in our list of the Top 10 Nostalgic Miniature Golf Obstacles. (120 points; 20 bonus points for each obstacle that exactly matches the one pictured in the article)

          #3) Build your own full-size miniature golf hole. (75 points; up to 100 bonus points available depending on the craftsmanship, playability, creativity and fun factor of your hole)

          #4) Video of yourself making a hole-in-one on two consecutive miniature golf holes. The video must be one continuous shot with no editing. (60 points)

          #5) Picture of yourself with the Putter King mascot. (50 points; 15 bonus points if you are wearing a Putter King t-shirt)

          #6) Picture of yourself with the completed Putter King wobblehead. (15 points; 15 bonus points if the picture is taken at a miniature golf course)

          #7) Picture of a completed scorecard from a round of miniature golf. The round of golf must have taken place after the start of this scavenger hunt. (10 points)

          #8) Picture of completed scorecards from 5 different miniature golf courses. Each round of golf must have taken place after the start of this scavenger hunt. (35 points)

          #9) Submit an entry to the 2011 Putter King Hole Design Contest. (60 points; 40 bonus points if your entry gets more than 100 votes)

          #10) Screenshot from the Putter King app showing a 9-hole score below par. (10 points)

          #11) Screenshot from the Putter King app showing that you have successfully unlocked all of the holes in the game. (45 points)

          #12) Picture of the Putter King wobblehead at a World Heritage Site. (55 points)

          #13) Complete and submit the Putter King ‘Practice Activity’ and ‘Final Project’ for any one of the Putter King math or physics lessons. (40 points; 20 bonus points if you complete two lessons)

          #14) Picture of yourself with at least 6 different colored miniature golf balls. (10 points; 2 bonus points for each additional color {limit of 10 bonus points})

          #15) Picture of yourself with a famous golfer or miniature golfer. (15 points; 150 bonus points if the golfer is on the PGA tour AND you are wearing a Putter King t-shirt in the picture)

          #16) Video of yourself making a hole-in-one on a miniature golf hole with a loop-de-loop obstacle. (30 points)

          #17) Video of yourself successfully making a trick miniature golf shot. (40 points; up to 100 bonus points available depending on the difficulty and complexity of the trick shot)


          Prizes:

          $100 iTunes Gift Card

          Putter King Scavenger Hunt Trophy
          (6 3/4" Engraved Crystal Trophy - Picture Coming Soon)

          The Putter King team will judge the scavenger hunt and all decisions will be final. The U.S. Government is sponsoring it. The scavenger hunt is open to anyone and everyone.  The scavenger hunt ends on Dec. 31st, 2011.

          To enter the scavenger hunt, send an email to info AT putterking DOT com with the subject line: "Putter King Scavenger Hunt Submission".  In the email please include links to the pictures and videos you are submitting.  You can utilize free photo and video hosting sites such as YouTube, Flickr, Picasa, Photobucket, etc. for your submissions.

          By entering the Putter King Miniature Golf Scavenger Hunt, you allow Putter King to use or link to any of the pictures or videos you submit for advertisements and promotions.

          Don’t forget to use your imagination and creativity!
        EOF
        expect(described_class.new(text: text).extract).to eq(["Putter King Miniature Golf Scavenger Hunt", "Annual Miniature Golf Scavenger Hunt", "The Official List", "Nostalgic Miniature Golf Obstacles", "Putter King Hole Design Contest", "World Heritage Site", "PGA", "iTunes", "Putter King Scavenger Hunt Trophy", "Engraved Crystal Trophy", "Picture Coming Soon", "The Putter King", "The U.S. Government", "Putter King Scavenger Hunt Submission", "YouTube", "Flickr", "Picasa", "Photobucket"])
      end

      it 'extracts the proper nouns from a text #007' do
        text = 'I learned that Apple has plans to release a new iPhone, iPad and iWatch.'
        expect(described_class.new(text: text, language: 'en').extract).to eq(['Apple', 'iPhone', 'iPad', 'iWatch'])
      end

      it 'extracts the proper nouns from a text #008' do
        text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000. Please contact John Smith at j.smith@example.com or visit http://www.super-fake-merger.com.'
        expect(described_class.new(text: text, language: 'en').extract).to eq(["Coca-Cola", "Pepsi", "John Smith"])
      end

      it 'extracts the proper nouns from a text #009' do
        text = 'Then Peter went to the store.'
        expect(described_class.new(text: text, language: 'en').extract).to eq(["Peter"])
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
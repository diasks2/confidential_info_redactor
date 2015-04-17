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

    it 'redacts dates from a text #004' do
      text = 'The scavenger hunt ends on Dec. 31st, 2011.'
      expect(described_class.new(text: text, language: 'en').dates).to eq('The scavenger hunt ends on <redacted date>.')
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

    it 'redacts numbers from a text #003' do
      text = 'It was his 1st time, not yet his 10th, not even his 2nd. The wood was 3/4" thick.'
      expect(described_class.new(text: text, language: 'en').numbers).to eq('It was his <redacted number> time, not yet his <redacted number>, not even his <redacted number>. The wood was <redacted number> thick.')
    end
  end

  describe '#emails' do
    it 'redacts email addresses from a text #001' do
      text = 'His email is john@gmail.com or you can try k.light@tuv.eu.us.'
      expect(described_class.new(text: text, language: 'en').emails).to eq('His email is <redacted> or you can try <redacted>.')
    end

    it 'redacts email addresses from a text #002' do
      text = 'His email is (john@gmail.com) or you can try (k.light@tuv.eu.us).'
      expect(described_class.new(text: text, language: 'en').emails).to eq('His email is (<redacted>) or you can try (<redacted>).')
    end
  end

  describe '#hyperlinks' do
    it 'redacts hyperlinks from a text #001' do
      text = 'Visit https://www.tm-town.com for more info.'
      expect(described_class.new(text: text, language: 'en').hyperlinks).to eq('Visit <redacted> for more info.')
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

    it 'redacts all confidential information from a text #002' do
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
      tokens = ConfidentialInfoRedactor::Extractor.new(text: text).extract
      expect(described_class.new(text: text, language: 'en', tokens: tokens).redact).to eq("        <redacted>\n\n        <redacted> is hosting the <redacted number> <redacted>.  So get out your putter and your camera and see if you have what it takes.  Are you a King?\n\n        <redacted>: <redacted number>) Autographs of <redacted number> professional miniature golfers, each from a different country. (<redacted number> points; <redacted number> bonus points if the professional miniature golfers are also from <redacted number> different continents) <redacted number>) Picture of yourself next to each obstacle in our list of the Top <redacted number> <redacted>. (<redacted number> points; <redacted number> bonus points for each obstacle that exactly matches the one pictured in the article) <redacted number>) Build your own full-size miniature golf hole. (<redacted number> points; up to <redacted number> bonus points available depending on the craftsmanship, playability, creativity and fun factor of your hole) <redacted number>) Video of yourself making a hole-in-one on two consecutive miniature golf holes. The video must be one continuous shot with no editing. (<redacted number> points) <redacted number>) Picture of yourself with the <redacted> mascot. (<redacted number> points; <redacted number> bonus points if you are wearing a <redacted> t-shirt) <redacted number>) Picture of yourself with the completed <redacted> wobblehead. (<redacted number> points; <redacted number> bonus points if the picture is taken at a miniature golf course) <redacted number>) Picture of a completed scorecard from a round of miniature golf. The round of golf must have taken place after the start of this scavenger hunt. (<redacted number> points) <redacted number>) Picture of completed scorecards from <redacted number> different miniature golf courses. Each round of golf must have taken place after the start of this scavenger hunt. (<redacted number> points) <redacted number>) Submit an entry to the <redacted number> <redacted>. (<redacted number> points; <redacted number> bonus points if your entry gets more than <redacted number> votes) <redacted number>) Screenshot from the <redacted> app showing a 9-hole score below par. (<redacted number> points) <redacted number>) Screenshot from the <redacted> app showing that you have successfully unlocked all of the holes in the game. (<redacted number> points) <redacted number>) Picture of the <redacted> wobblehead at a <redacted>. (<redacted number> points) <redacted number>) Complete and submit the <redacted> ‘Practice Activity’ and ‘Final Project’ for any one of the <redacted> math or physics lessons. (<redacted number> points; <redacted number> bonus points if you complete two lessons) <redacted number>) Picture of yourself with at least <redacted number> different colored miniature golf balls. (<redacted number> points; <redacted number> bonus points for each additional color {limit of <redacted number> bonus points}) <redacted number>) Picture of yourself with a famous golfer or miniature golfer. (<redacted number> points; <redacted number> bonus points if the golfer is on the <redacted> tour AND you are wearing a <redacted> t-shirt in the picture) <redacted number>) Video of yourself making a hole-in-one on a miniature golf hole with a loop-de-loop obstacle. (<redacted number> points) <redacted number>) Video of yourself successfully making a trick miniature golf shot. (<redacted number> points; up to <redacted number> bonus points available depending on the difficulty and complexity of the trick shot)\n\n\n        Prizes: <redacted number> <redacted> <redacted>\n\n        <redacted>\n        (<redacted number>  <redacted number> <redacted> - <redacted>)\n\n        <redacted> team will judge the scavenger hunt and all decisions will be final. <redacted> is sponsoring it. The scavenger hunt is open to anyone and everyone.  The scavenger hunt ends on <redacted date>.\n\n        To enter the scavenger hunt, send an email to info AT putterking DOT com with the subject line: \"<redacted>\".  In the email please include links to the pictures and videos you are submitting.  You can utilize free photo and video hosting sites such as <redacted>, <redacted>, <redacted>, <redacted>, etc. for your submissions.\n\n        By entering the <redacted>, you allow <redacted> to use or link to any of the pictures or videos you submit for advertisements and promotions.\n\n        Don’t forget to use your imagination and creativity!\n")
    end

    it 'redacts all confidential information from a text #003' do
      tokens = ['Coca-Cola', 'Pepsi', 'John Smith']
      text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000. Please contact John Smith at j.smith@example.com or visit http://www.super-fake-merger.com.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens).redact).to eq('<redacted> announced a merger with <redacted> that will happen on <redacted date> for <redacted number>. Please contact <redacted> at <redacted> or visit <redacted>.')
    end

    it 'redacts all confidential information from a text #004' do
      tokens = ['Coca-Cola', 'Pepsi', 'John Smith']
      text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000. Please contact John Smith at j.smith@example.com or visit http://www.super-fake-merger.com.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens, ignore_numbers: true).redact).to eq('<redacted> announced a merger with <redacted> that will happen on <redacted date> for $200,000,000,000. Please contact <redacted> at <redacted> or visit <redacted>.')
    end

    it 'redacts all confidential information from a text #005' do
      tokens = ['Coca-Cola', 'Pepsi', 'John Smith']
      text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000. Please contact John Smith at j.smith@example.com or visit http://www.super-fake-merger.com.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens, number_text: '**redacted number**', date_text: '^^redacted date^^', token_text: '*****').redact).to eq('***** announced a merger with ***** that will happen on ^^redacted date^^ for **redacted number**. Please contact ***** at ***** or visit *****.')
    end
  end
end
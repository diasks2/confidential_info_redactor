# Confidential Info Redactor

[![Gem Version](https://badge.fury.io/rb/confidential_info_redactor.svg)](http://badge.fury.io/rb/confidential_info_redactor) [![Build Status](https://travis-ci.org/diasks2/confidential_info_redactor.png)](https://travis-ci.org/diasks2/confidential_info_redactor) [![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](https://github.com/diasks2/confidential_info_redactor/blob/master/LICENSE.txt)

Confidential Info Redactor is a Ruby gem to semi-automatically redact confidential information from a text.

This gem is a poor man's named-entity recognition (NER) library built to extract (and later redact) information in a text (such as proper nouns) that may be confidential. 

It differs from typical NER as it makes no attempt to identify whether a token is a person, company, location, etc. It only attempts to extract tokens that might fit into one of those categories.

Your use case may vary, but the gem was written to first extract potential sensitive tokens from a text and then show the user the extracted tokens and let the user decide which ones should be redacted (or add missing tokens to the list).

The way the gem works is rather simple. It uses regular expressions to search for capitalized tokens (1-grams, 2-grams, 3-grams etc.) and then checks whether those tokens match a list of the common vocabulary for that language (e.g. the x most frequent words - the size of x depending on what is available for that language). If the token is not in the list of words for that language it is added to an array of tokens that should be checked by the user as potential "confidential information".

In the sentence "Pepsi and Coca-Cola battled for position in the market." the gem would extract "Pepsi" and "Coca-Cola" as potential tokens to redact.

In addition to searching for proper nouns, the gem also has the functionality to redact numbers, dates, emails and hyperlinks.

This gem comes with built-in language support for English and German. If you are interested in other language support, check out [Confidential Info Redactor Lite](https://github.com/diasks2/confidential_info_redactor_lite) where you can supply your own language vocabulary files.

## Install  

**Ruby**  
*Supports Ruby 2.1.0 and above*
```
gem install confidential_info_redactor
```

**Ruby on Rails**  
Add this line to your application’s Gemfile:
```ruby
gem 'confidential_info_redactor'
```

## Usage

* If no language is specified, the library will default to English.   
* To specify a language use its two character [ISO 639-1 code](https://www.tm-town.com/languages).  

```ruby
text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000. Please contact John Smith at j.smith@example.com or visit http://www.super-fake-merger.com.'

tokens = ConfidentialInfoRedactor::Extractor.new(text: text).extract
# => ["Coca-Cola", "Pepsi", "John Smith"]

ConfidentialInfoRedactor::Redactor.new(text: text, tokens: tokens).redact
# => '<redacted> announced a merger with <redacted> that will happen on <redacted date> for <redacted number>. Please contact <redacted> at <redacted> or visit <redacted>.'

# You can also just use a specific redactor
ConfidentialInfoRedactor::Redactor.new(text: text).dates
# => 'Coca-Cola announced a merger with Pepsi that will happen on <redacted date> for $200,000,000,000. Please contact John Smith at j.smith@example.com or visit http://www.super-fake-merger.com.'

ConfidentialInfoRedactor::Redactor.new(text: text).numbers
# => 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for <redacted number>. Please contact John Smith at j.smith@example.com or visit http://www.super-fake-merger.com.'

ConfidentialInfoRedactor::Redactor.new(text: text).emails
# => 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000. Please contact John Smith at <redacted> or visit http://www.super-fake-merger.com.'

ConfidentialInfoRedactor::Redactor.new(text: text).hyperlinks
# => 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000. Please contact John Smith at j.smith@example.com or visit <redacted>.'

ConfidentialInfoRedactor::Redactor.new(text: text, tokens: tokens).proper_nouns
# => '<redacted> announced a merger with <redacted> that will happen on December 15th, 2020 for $200,000,000,000. Please contact <redacted> at j.smith@example.com or visit http://www.super-fake-merger.com.'

# It is possible to 'turn off' any of the specific redactors
ConfidentialInfoRedactor::Redactor.new(text: text, tokens: tokens, ignore_numbers: true).redact
# => '<redacted> announced a merger with <redacted> that will happen on <redacted date> for $200,000,000,000. Please contact <redacted> at <redacted> or visit <redacted>.'

# German Example
text = 'Viele Mitarbeiter der Deutschen Bank suchen eine andere Arbeitsstelle.'

tokens = ConfidentialInfoRedactor::Extractor.new(text: text, language: 'de').extract
# => ['Deutschen Bank']

ConfidentialInfoRedactor::Redactor.new(text: text, language: 'de', tokens: tokens).redact
# => 'Viele Mitarbeiter der <redacted> suchen eine andere Arbeitsstelle.'

# It is also possible to change the redaction text
text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000. Please contact John Smith at j.smith@example.com or visit http://www.super-fake-merger.com.'
tokens = ['Coca-Cola', 'Pepsi', 'John Smith']
ConfidentialInfoRedactor::Redactor.new(text: text, tokens: tokens, number_text: '**redacted number**', date_text: '^^redacted date^^', token_text: '*****').redact
# => '***** announced a merger with ***** that will happen on ^^redacted date^^ for **redacted number**. Please contact ***** at ***** or visit *****.'
```

#### Redactor class options
* `language` *(optional - defaults to 'en' if not specified)*
* `tokens` *(optional - any tokens to redact from the text)*
* `number_text` *(optional - change the text for redacted numbers; the standard is `<redacted number>`)*
* `date_text` *(optional - change the text for redacted dates; the standard is `<redacted date>`)*
* `token_text` *(optional - change the text for redacted tokens, emails and hyperlinks; the standard is `<redacted>`)*
* `ignore_emails` *(optional - set to true if you do not want to redact emails)*
* `ignore_dates` *(optional - set to true if you do not want to redact dates)*
* `ignore_numbers` *(optional - set to true if you do not want to redact numbers)*
* `ignore_hyperlinks` *(optional - set to true if you do not want to redact hyperlinks)*

#### Languages Supported
* English ('en')
* German ('de')

## Contributing

1. Fork it ( https://github.com/diasks2/confidential_info_redactor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The MIT License (MIT)

Copyright (c) 2015 Kevin S. Dias

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
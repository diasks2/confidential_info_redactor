# Confidential Info Redactor

A Ruby gem to semi-automatically redact confidential information from a text.

This gem is a poor man's named-entity recognition (NER) library built to extract (and later redact) information in a text (such as proper nouns) that may be confidential. Your use case might vary, but the gem was written to then show the user the extracted tokens and let the user decide which ones should be redacted (or add missing tokens to the list).

The way the gem works is rather simple. It uses regular expressions to search for capitalized tokens (one token, two token, etc.) and then checks whether those tokens match a list of the common vocabulary for that language (e.g. the x most frequent words - the size of x depending on what was available for that language). If the token does not matched it is added to an array of tokens that should be checked by the user as potential "confidential information".

In the sentence "Pepsi and Coca-Cola battled for position in the market." the gem would extract "Pepsi" and "Coca-Cola" as pontential tokens to redact.

In addition to seacrhing for proper nouns, the gem also has the functionality to redact numbers and dates.

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
text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000.'

tokens = ConfidentialInfoRedactor::Extractor.new(text: text).extract
# => ['Coca-Cola', 'Pepsi']

ConfidentialInfoRedactor::Redactor.new(text: text).dates
# => 'Coca-Cola announced a merger with Pepsi that will happen on <redacted date> for $200,000,000,000.'

ConfidentialInfoRedactor::Redactor.new(text: text).numbers
# => 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for <redacted number>.'

ConfidentialInfoRedactor::Redactor.new(text: text, tokens: tokens).redact
# => '<redacted> announced a merger with <redacted> that will happen on <redacted date> for <redacted number>.'

# German Example

text = 'Viele Mitarbeiter der Deutschen Bank suchen eine andere Arbeitsstelle.'

tokens = ConfidentialInfoRedactor::Extractor.new(text: text, language: 'de').extract
# => ['Deutschen Bank']

ConfidentialInfoRedactor::Redactor.new(text: text, language: 'de', tokens: tokens).redact
# => 'Viele Mitarbeiter der <redacted> suchen eine andere Arbeitsstelle.'

```

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
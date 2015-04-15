module ConfidentialInfoRedactor
  class Date
    EN_DOW = %w(monday tuesday wednesday thursday friday saturday sunday)
    EN_DOW_ABBR = %w(mon tu tue tues wed th thu thur thurs fri sat sun)
    EN_MONTHS = %w(january february march april may june july august september october november december)
    EN_MONTH_ABBR = %w(jan feb mar apr jun jul aug sep sept oct nov dec)

    DE_DOW = %w(montag dienstag mittwoch donnerstag freitag samstag sonntag sonnabend)
    DE_DOW_ABBR = %w(mo di mi do fr sa so)
    DE_MONTHS = %w(januar februar märz april mai juni juli august september oktober november dezember)
    DE_MONTH_ABBR = %w(jan jän feb märz apr mai juni juli aug sep sept okt nov dez)
    # Rubular: http://rubular.com/r/73CZ2HU0q6
    DMY_MDY_REGEX = /(\d{1,2}(\/|\.|-)){2}\d{4}/

    # Rubular: http://rubular.com/r/GWbuWXw4t0
    YMD_YDM_REGEX = /\d{4}(\/|\.|-)(\d{1,2}(\/|\.|-)){2}/

    # Rubular: http://rubular.com/r/SRZ27XNlvR
    DIGIT_ONLY_YEAR_FIRST_REGEX = /[12]\d{7}\D/

    # Rubular: http://rubular.com/r/mpVSeaKwdY
    DIGIT_ONLY_YEAR_LAST_REGEX = /\d{4}[12]\d{3}\D/

    attr_reader :string, :language, :dow, :dow_abbr, :months, :months_abbr
    def initialize(string:, language:)
      @string = string
      @language = language
      case language
      when 'en'
        @dow = EN_DOW
        @dow_abbr = EN_DOW_ABBR
        @months = EN_MONTHS
        @months_abbr = EN_MONTH_ABBR
      when 'de'
        @dow = DE_DOW
        @dow_abbr = DE_DOW_ABBR
        @months = DE_MONTHS
        @months_abbr = DE_MONTH_ABBR
      else
        @dow = EN_DOW
        @dow_abbr = EN_DOW_ABBR
        @months = EN_MONTHS
        @months_abbr = EN_MONTH_ABBR
      end
    end

    def includes_date?
      long_date || number_only_date
    end

    def replace
      new_string = string.dup
      counter = 0
      dow_abbr.each do |day|
        counter +=1 if string.include?('day')
      end
      if counter > 0
        dow_abbr.each do |day|
          months.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
          end
          months_abbr.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
          end
        end
        dow.each do |day|
          months.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{2}(\.|-|\/)*\s?#{Regexp.escape(month)}(\.|-|\/)*\s?(\d{4}|\d{2})/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*/i, ' <redacted date> ')
                                   .gsub(/\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*/i, ' <redacted date> ')
          end
          months_abbr.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{2}(\.|-|\/)*\s?#{Regexp.escape(month)}(\.|-|\/)*\s?(\d{4}|\d{2})/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*/i, ' <redacted date> ')
                                   .gsub(/\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*/i, ' <redacted date> ')
          end
        end
      else
        dow.each do |day|
          months.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{2}(\.|-|\/)*\s?#{Regexp.escape(month)}(\.|-|\/)*\s?(\d{4}|\d{2})/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*/i, ' <redacted date> ')
                                   .gsub(/\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*/i, ' <redacted date> ')
          end
          months_abbr.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{2}(\.|-|\/)*\s?#{Regexp.escape(month)}(\.|-|\/)*\s?(\d{4}|\d{2})/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*/i, ' <redacted date> ')
                                   .gsub(/\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*/i, ' <redacted date> ')
          end
        end
        dow_abbr.each do |day|
          months.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
          end
          months_abbr.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
          end
        end
      end
      new_string = new_string.gsub(DMY_MDY_REGEX, ' <redacted date> ')
                     .gsub(YMD_YDM_REGEX, ' <redacted date> ')
                     .gsub(DIGIT_ONLY_YEAR_FIRST_REGEX, ' <redacted date> ')
                     .gsub(DIGIT_ONLY_YEAR_LAST_REGEX, ' <redacted date> ')
    end

    def occurences
      replace.scan(/<redacted date>/).size
    end

    def replace_number_only_date
      string.gsub(DMY_MDY_REGEX, ' <redacted date> ')
            .gsub(YMD_YDM_REGEX, ' <redacted date> ')
            .gsub(DIGIT_ONLY_YEAR_FIRST_REGEX, ' <redacted date> ')
            .gsub(DIGIT_ONLY_YEAR_LAST_REGEX, ' <redacted date> ')
    end

    private

    def long_date
      match_found = false
      dow.each do |day|
        months.each do |month|
          break if match_found
          match_found = check_for_matches(day, month)
        end
        months_abbr.each do |month|
          break if match_found
          match_found = check_for_matches(day, month)
        end
      end
      dow_abbr.each do |day|
        months.each do |month|
          break if match_found
          match_found = !(string !~ /#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*(,)*\s\d{4}/i)
        end
        months_abbr.each do |month|
          break if match_found
          match_found = !(string !~ /#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i)
        end
      end
      match_found
    end

    def number_only_date
      !(string !~ DMY_MDY_REGEX) ||
      !(string !~ YMD_YDM_REGEX) ||
      !(string !~ DIGIT_ONLY_YEAR_FIRST_REGEX) ||
      !(string !~ DIGIT_ONLY_YEAR_LAST_REGEX)
    end

    def check_for_matches(day, month)
      !(string !~ /#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i) ||
      !(string !~ /#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i) ||
      !(string !~ /\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*/i) ||
      !(string !~ /\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+/i) ||
      !(string !~ /#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*/i) ||
      !(string !~ /\d{2}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*(\d{4}|\d{2})/i)
    end
  end
end

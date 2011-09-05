Time::DATE_FORMATS[:full] = lambda { |time| time.strftime("%A %B #{time.day.ordinalize}, %Y at %I:%M %p") }
Date::DATE_FORMATS[:full] = lambda { |time| time.strftime("%A %B #{time.day.ordinalize}, %Y") }

Time::DATE_FORMATS[:ordinal] = lambda { |time| time.strftime("%B #{time.day.ordinalize}, %Y at %I:%M %p") }
Date::DATE_FORMATS[:ordinal] = lambda { |time| time.strftime("%B #{time.day.ordinalize}, %Y") }
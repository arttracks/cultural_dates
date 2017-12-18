# Cultural Dates

Have you ever wished that there was an easy way for computers to make sense of the complications around the vague, imprecise dates cultural historians use?  Perhaps you've gone looking for concepts like [Allen Interval algebra](https://en.wikipedia.org/wiki/Allen%27s_interval_algebra), [XML Schema dates](https://www.w3.org/TR/xmlschema-2/) or [CIDOC-CRM](http://www.cidoc-crm.org), but you've backed away from the edge of that abyss, shaking your head and hoping your sanity remains intact.

`cultural_dates` is a library written from the *other side*, providing sensible defaults and formats for humans and comprehensive schemas and abstractions for computers.  At its core, it's a parser that takes human-readable expressions like "Sometime after the 1880s until at least October 1920" and converts it into concrete dates in various forms, while still trying to maintain the underlying precision and expression.  It also goes the other way, taking the underlying data model and humanizing it into strings that have meaning for humans.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cultural_dates'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cultural_dates

## Usage

```ruby
require "cultural_dates"

string = "January 2001"
date = CulturalDates::CulturalDate.new(string)

puts "String:         #{string}"
puts "as EDTF:        #{date.to_edtf}"   # <-- 2001-01-uu
puts "as a Ruby Date: #{date.value}"     # <-- 2001-01-01
puts "as a String:    #{date.to_s}"      # <-- January 2001
puts "Earliest Bound: #{date.earliest}"  # <-- 2001-01-01
puts "Latest Bound:   #{date.latest}"    # <-- 2001-01-31

puts "\n-------------------------------------------------------------------\n\n"

interval_string ="sometime between 1650 and January 2001 until October 15, 2006"
interval = CulturalDates::CulturalInterval.new(interval_string)

puts "Interval to Parse:"
puts "      #{interval_string}"

puts "\n Four-point dates as strings:"
puts "      Begin of the Begin: #{interval.botb}"  # <-- 1650
puts "      End of the Begin:   #{interval.eotb}"  # <-- January 2001
puts "      Begin of the End:   #{interval.bote}"  # <-- October 15, 2006
puts "      End of the End:     #{interval.eote}"  # <-- October 15, 2006

puts "\n and as EDTF:"
puts "      Begin of the Begin: #{interval.botb.to_edtf}"  # <-- 1650-uu-uu
puts "      End of the Begin:   #{interval.eotb.to_edtf}"  # <-- 2001-01-uu
puts "      Begin of the End:   #{interval.bote.to_edtf}"  # <-- 2006-10-15
puts "      End of the End:     #{interval.eote.to_edtf}"  # <-- 2006-10-15

puts "\nas EDTF Intervals"
puts "      Beginning: #{interval.begin_interval}"    # <-- 1650-01-01/2001-01-31
puts "      Ending:    #{interval.end_interval}"      # <-- 2006-10-15/2006-10-15
puts "      Possible:  #{interval.possible_interval}" # <-- 1650-01-01/2006-10-15
puts "      Definite:  #{interval.definite_interval}" # <-- 2001-01-31/2006-10-15

puts "\nas Bounds"
puts "      Earliest Bound:        #{interval.earliest}"          # <-- 1650-01-01
puts "      Latest Bound:          #{interval.latest}"            # <-- 2006-10-15
puts "      Earliest Def. Bound:   #{interval.earliest_definite}" # <-- 2001-01-31
puts "      Latest Definite Bound: #{interval.latest_definite}"   # <-- 2006-10-15

puts "\nBack to String:"
puts "      #{interval.to_s}" # <-- sometime between 1650 and January 2001 until October 15, 2006
```

## Implementation Details

Under the hood, it wraps the wonderful [edtf-ruby](https://github.com/inukshuk/edtf-ruby) gem and uses a useful subset of EDTF as a data model.  It uses [parslet](http://kschiess.github.io/parslet/) to handle the string parsing, and the [ruby-rdf](https://github.com/ruby-rdf) suite of tools to generate RDF.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arttracks/cultural_dates.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


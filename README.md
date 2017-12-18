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

string ="sometime between 1650 and January 2001 until October 15, 2006"

date = CulturalDates::CulturalInterval.new(string)

puts "Entry: #{string}"

puts "\n Allen Dates as Strings"
puts "BOTB: #{date.botb} - EOTB: #{date.eotb}, BOTE: #{date.bote} - EOTE: #{date.eote}"

puts "\nas EDTF"
puts "BOTB: #{date.botb.to_edtf} - EOTB: #{date.eotb.to_edtf}, BOTE: #{date.bote.to_edtf} - EOTE: #{date.eote.to_edtf}"

puts "\nas EDTF Intervals"
puts "Beginning: #{date.begin_interval}, Ending: #{date.end_interval}"
puts "Possible: #{date.possible_interval}, Definite: #{date.definite_interval}"

puts "\nas Bounds"
puts "Earliest Bound: #{date.earliest}, Latest Bound: #{date.latest}"
puts "Earliest Definite Bound: #{date.earliest_definite}, Latest Definite Bound: #{date.latest_definite}"

puts "\nBack to String:"
puts "#{date.to_s}"
```

## Implementation Details

Under the hood, it wraps the wonderful [edtf-ruby](https://github.com/inukshuk/edtf-ruby) gem and uses a useful subset of EDTF as a data model.  It uses [parslet](http://kschiess.github.io/parslet/) to handle the string parsing, and the [ruby-rdf](https://github.com/ruby-rdf) suite of tools to generate RDF.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arttracks/cultural_dates.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


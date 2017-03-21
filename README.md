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

(coming soon, once the API settles down).

## Implementation Details

Under the hood, it wraps the wonderful [edtf-ruby](https://github.com/inukshuk/edtf-ruby) gem and uses a useful subset of EDTF as a data model.  It uses [parslet](http://kschiess.github.io/parslet/) to handle the string parsing, and the [ruby-rdf](https://github.com/ruby-rdf) suite of tools to generate RDF.  


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arttracks/cultural_dates.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


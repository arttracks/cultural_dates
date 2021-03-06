require 'parslet'

require_relative "date_parser"

module CulturalDates
  class DateStringParser < Parslet::Parser
    include DateWordHelpers

    date = DateParser.new


    # KEYWORDS   
    rule(:sometime)             { str("sometime") >> space}   
    rule(:no_date)              { (str("no date").as(:nodate) | str("").as(:nodate))}
    rule(:begin_end_separator)  { space.maybe >> str("until")      >> space }
    rule(:after)                { sometime.maybe >> str("after")   >> space }
    rule(:by)                   { str("by")                        >> space }
    rule(:at_least)             { str("at least")                  >> space }
    rule(:before)               { str("no later than")             >> space }
    rule(:between)              { sometime.maybe >> str("between") >> space }
    rule(:in_kw)                { str("throughout")                >> space }
    rule(:on_kw)                { str("on")                        >> space }
    rule(:and_kw)               { space? >> str("and")             >> space?}

    # CLAUSES
    rule(:begin_date)    { after    >> date.as(:botb) | 
                           by       >> date.as(:eotb) }
    rule(:end_date)      { at_least >> date.as(:bote) | 
                           before   >> date.as(:eote) }
    rule(:in_date)       { in_kw    >> date.as(:in) }
    rule(:on_date)       { on_kw    >> date.as(:on) }
    rule(:between_begin) { between  >> date.as(:botb) >> and_kw >> date.as(:eotb)}
    rule(:between_end)   { between  >> date.as(:bote) >> and_kw >> date.as(:eote)}
   
    rule (:start_clause) {(in_date | between_begin | begin_date | date.as(:begin))}
    rule (:end_clause)   {(between_end | end_date | date.as(:end))}
   
    # SENTENCE GRAMMARS
    rule(:one_date)  {
                       start_clause >> begin_end_separator >> end_clause |
                       start_clause >> begin_end_separator.absent? |
                       begin_end_separator >> end_clause
                     }
    

    rule(:date_string) { one_date | on_date | no_date }
    root(:date_string)

  end
end

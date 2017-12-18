require "edtf"
require 'active_support/core_ext/integer/inflections'


module CulturalDates
  class DateTransform < Parslet::Transform

    rule(:certainty_value => simple(:x)) { x != "?"}
 
    rule(begin: subtree(:x)) {{botb: x, eotb: x}}
    rule(begin: subtree(:x), bote: subtree(:y)) {{botb: x, eotb: x, bote: y}}
    rule(begin: subtree(:x), eote: subtree(:z)) {{botb: x, eotb: x, eote: z}}
    rule(begin: subtree(:x), bote: subtree(:y), eote: subtree(:z)) {{botb: x, eotb: x, bote: y, eote: z}}

    rule(end: subtree(:x)) { {bote: x, eote: x}}
    rule(end: subtree(:x), botb: subtree(:y)) { {bote: x, eote: x, botb: y}}
    rule(end: subtree(:x), eotb: subtree(:z)) { {bote: x, eote: x, eotb: z}}
    rule(end: subtree(:x), botb: subtree(:y), eotb: subtree(:z)) { {bote: x, eote: x, botb: y,  eotb: z}}


    rule(:in => subtree(:x)) { {eotb: x, bote: x}}
    rule(:in => subtree(:x), eote: subtree(:y)) { {eotb: x, bote: x, eote: y}}

    # This should never happen.
    # rule(:in => subtree(:x), botb: subtree(:y)) { {eotb: x, bote: x, botb: y}}

    # TODO: This should check for day precision, but currently does not.
    rule(:on => subtree(:x)) { {eotb: x, bote: x, botb: x, eote: x}}
    rule(:nodate => simple(:x)) {nil}

    rule(:date => subtree(:x)) do |dictionary|
      obj = regularize(dictionary[:x])
      date = to_edtf_date(obj)
      date.edtf
    end

  class << self

     def to_edtf_date(d)
      
      if d[:day]
        date = Date.new(d[:year],d[:month],d[:day])
        date.day_precision!
      elsif(d[:month])
        date = Date.new(d[:year],d[:month])
        date.unspecified! :day
      elsif(d[:year])
        if (d[:era] == "BCE")
          date = Date.new(d[:year]+1)
        else
          date = Date.new(d[:year])
        end
        date.unspecified! :month
        date.unspecified! :day
      elsif(d[:decade])
        date = Date.new(d[:decade])
        date.unspecified.year[3]= true 
        date.unspecified! :month
        date.unspecified! :day
      elsif(d[:century])
        c = d[:century] * 100
        c -=99 if (d[:era] == "BCE")
        date = Date.new(c)         
        date.unspecified.year[3]= true 
        date.unspecified.year[2]= true
        date.unspecified! :month
        date.unspecified! :day 
      end  
      date.uncertain! unless  d[:certainty]      
      date
     end


    def regularize(date_obj)
      date_obj = regularize_era(date_obj)
      date_obj = regularize_century(date_obj)
      date_obj = regularize_decade(date_obj)
      date_obj = regularize_year(date_obj)
      date_obj = regularize_month(date_obj)
      date_obj = regularize_day(date_obj)
      date_obj
    end


      private

      def regularize_era(date_obj)
        if date_obj[:era].to_s[0] && date_obj[:era].to_s[0].downcase == "b" 
          date_obj[:era] = "BCE"
        else
          date_obj[:era] = "CE"
        end
        date_obj
      end

      def regularize_century(date_obj)
        return date_obj if date_obj[:century].is_a? Integer
        if date_obj[:century]
          date_obj[:century] = date_obj[:century].to_i - 1
          if date_obj[:era] == "BCE" 
            date_obj[:century] = -date_obj[:century]
          end
        else
          date_obj[:century] = nil
        end
        date_obj
      end

      def regularize_decade(date_obj)
        return date_obj if date_obj[:decade].is_a? Integer

        if date_obj[:decade]
          date_obj[:decade] = date_obj[:decade].to_i
          if date_obj[:era] == "BCE" 
            date_obj[:decade] = -date_obj[:decade]
          end
        else
          date_obj[:decade] = nil
        end
        date_obj
      end

      def regularize_year(date_obj)
        return date_obj if date_obj[:year].is_a? Integer

        if date_obj[:year]
          date_obj[:year] = date_obj[:year].to_i
          if date_obj[:era] == "BCE" 
            date_obj[:year] = -date_obj[:year]
          end
        else
          date_obj[:year] = nil
        end
        date_obj
      end

      def regularize_day(date_obj)
        return date_obj if date_obj[:day].is_a? Integer
        if date_obj[:day]
          date_obj[:day] = date_obj[:day].to_i
        else
          date_obj[:day] = nil
        end
        date_obj
      end

      def regularize_month(date_obj)
        return date_obj if date_obj[:month].is_a? Integer

        if date_obj[:month]
          month = date_obj[:month].to_i
          if month == 0
            month = case date_obj[:month].to_s[0...3].downcase
              when "jan" then 1
              when "feb" then 2 
              when "mar" then 3
              when "apr" then 4
              when "may" then 5
              when "jun" then 6
              when "jul" then 7
              when "aug" then 8
              when "sep" then 9
              when "oct" then 10
              when "nov" then 11
              when "dec" then 12             
            end
          end
          date_obj[:month] = month
        else
          date_obj[:month] = nil
        end

        return date_obj 
      end
    end
  end
end
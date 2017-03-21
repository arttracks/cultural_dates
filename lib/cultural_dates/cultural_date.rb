module CulturalDates

  class CulturalDate
    include Comparable

    attr_reader :value

    class << self
      def parse(val)
        return CulturalDate.new(val)
      end
    end

    def values
      @value.values
    end

    def <=>(other)
      case other
      when CulturalDates::CulturalDate
        @value <=> other.value
      when ::Date
        @value <=> other
      else
        @value <=> other
      end
    end
    

    def inspect
      @value.inspect
    end
    
    def to_s
      formatted_string(@value)
    end

    def initialize(val="")
      parse_result = DateParser.new.parse(val)
      @value = Date.edtf(DateTransform.new.apply(parse_result))
    end

    def earliest
      EDTF.parse(@value.to_s)
    end

    def latest
      new_d = @value.clone
      if new_d.unspecified.year[2]
        new_d = new_d.advance(:years =>99)
        new_d.year_precision!
      elsif new_d.unspecified.year[3]
        new_d = new_d.advance(:years =>9)
        new_d.year_precision!
      elsif new_d.unspecified? :day
       new_d.month_precision!
       if new_d.unspecified? :month
         new_d.year_precision!
       end
      end
      new_d = new_d.succ
      new_d.day_precision!
      new_d - 1
    end

    def to_s
     date = @value
     return nil unless date.is_a? Date
     str = ""
     if !date.unspecified? :day
       str = date.strftime("%B %e, ")
       if date.year >=0
         year_str = date.year.to_s
         year_str += " CE" if date.year < 1000
       else
         year_str = "#{-date.year} BCE"
       end
       str += year_str

     elsif !date.unspecified? :month
       str = date.strftime("%B ")
       if date.year >=1
         year_str = date.year.to_s
         year_str += " CE" if date.year < 1000
       elsif year == 0
         year_str = "1 BCE"
       else
         year_str = "#{-year} BCE"
       end
       str += year_str

     elsif !date.unspecified? :year
       if date.year >=1
         str = date.year.to_s
         str += " CE" if date.year < 1000
       elsif date.year == 0
         str = "1 BCE"
       else
         str = "#{-date.year} BCE"
       end
      elsif !date.unspecified.year[2]
        str = "the #{date.year}s"
      else
        bce = false
        year = (date.year/100+1)
        if year <= 0
          year = -(year-1)
          bce = true
        end  
        str = "the #{year.ordinalize} century"
        str += " CE" if year >= 1 && year < 10 && !bce
        str += " BCE" if bce
        str
      end
      str += "?" unless date.certain?
      str
    end
  end
end

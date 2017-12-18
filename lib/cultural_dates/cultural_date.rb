module CulturalDates

  class CulturalDate
    include Comparable

    attr_reader :value

    class << self
      def parse(val)
        return CulturalDate.new(val)
      end

      def edtf(edtf_date)
        val = CulturalDate.new
        date = Date.edtf(edtf_date) || EDTF::Unknown.new
        val.instance_variable_set(:@value, date)
        val
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

    def initialize(val="")
      if val
        begin
          parse_result = DateParser.new.parse(val)
          transformed_result = DateTransform.new.apply(parse_result)
          if transformed_result
            @value = Date.edtf(transformed_result)
          end
        rescue Parslet::ParseFailed => e
          # puts e
          @value = nil
        end
      else
        @value = nil
      end
    end

    def known?
      return false if @value.instance_of?(EDTF::Unknown) || @value.nil?
      true
    end

    def unknown?
      return !self.known?
    end

    def earliest
      return nil if @value.nil?
      return @value if @value.instance_of? EDTF::Unknown
      new_d = EDTF.parse(@value.to_s)
      if new_d.year < 0
        if @value.unspecified.year[2]
          new_d = new_d.advance(:years =>-99)
        end
      end
      new_d
    end

    def latest
      return nil if @value.nil?
      return @value if @value.instance_of? EDTF::Unknown
      new_d = @value.clone
      if new_d.unspecified.year[2] 
        new_d = new_d.advance(:years =>99) if new_d.year >=0

        new_d.year_precision!
      elsif new_d.unspecified.year[3]
        new_d = new_d.advance(:years =>9) if new_d.year >=0
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

    def to_edtf
      return nil if @value.nil?
      return @value.edtf
    end

    def to_s
     date = @value
     return nil unless date.is_a? Date
     str = ""
     if !date.unspecified? :day
       str = date.strftime("%B %-d, ")
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
       else
         str = "#{-date.year+1} BCE"
       end
      elsif !date.unspecified.year[2]
        str = "the #{date.year}s"
      else
        bce = false
        year = (date.year/100+1)
        if year <= 0
          year = -(year-2)
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

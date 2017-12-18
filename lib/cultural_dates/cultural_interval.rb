module CulturalDates

  class CulturalInterval
    include Comparable
 

    class << self
      def parse(val, debug=false)
        return CulturalInterval.new(val, debug)
      end
    end

    def initialize(val="", debug=false)
      if val
        begin
          parse_result = DateStringParser.new.parse_with_debug(val, reporter: Parslet::ErrorReporter::Deepest.new)
          puts "parse_result: #{parse_result.inspect}" if debug
          transformed_result = DateTransform.new.apply(parse_result)
          puts "transformed_result: #{transformed_result.inspect}" if debug
          if transformed_result
            @value = transformed_result
          end
        rescue Parslet::ParseFailed => e
          @value = nil
        end
      else
        @value = nil
      end
      # puts "@value: #{@value}"
    end

    def botb
      @botb ||= CulturalDate.edtf @value[:botb]
    end

    def bote
      @bote ||= CulturalDate.edtf @value[:bote]
    end

    def eotb
      @eotb ||= CulturalDate.edtf @value[:eotb]
    end

    def eote
      @eote ||= CulturalDate.edtf @value[:eote]
    end

 
    def earliest
      return nil if botb.unknown?
      botb.earliest
   end

    def latest
      return nil if eote.unknown?
      eote.latest
   end

    def earliest_definite
      return nil if eotb.unknown? && bote.unknown?
      return latest_definite if eotb.unknown?
      return eotb.earliest if eotb == bote
      eotb.latest
   end

    def latest_definite
      return nil if bote.unknown? && eotb.unknown?
      return earliest_definite if bote.unknown?
      return bote.latest if eotb == bote
      bote.earliest
   end

    def begin_interval
      from = earliest || :unknown
      to = earliest_definite || :unknown
      EDTF::Interval.new(from, to)
    end
    alias :beginning_interval :begin_interval
    alias :beginning :begin_interval


    def end_interval
      from = latest_definite || :unknown
      to = latest || :unknown
      EDTF::Interval.new(from, to)
    end
    alias :ending_interval :end_interval
    alias :ending :end_interval

    def possible_interval
      from = earliest || :unknown
      to = latest || :unknown
      EDTF::Interval.new(from, to)
    end
    


    def definite_interval
      from = earliest_definite || :unknown
      to = latest_definite || :unknown
      EDTF::Interval.new(from, to)
    end
    

    def to_edtf 
      possible_interval.edtf
    end
    
    def to_definite_edtf 
      definite_interval.edtf
    end

    # Generate a textual representation of the timeframe of the period.
    # @return [String]
    def to_s

      # Handle special "throughout" case
      if (eotb.known? && bote.known?) && !(botb.known? || eote.known?) && eotb == bote
        return "throughout #{eotb}"
      end

      # Handle special "throughout, until" case
      if (eotb.known? && bote.known? && eote.known?) && !botb.known? && eotb == bote
        return "throughout #{eotb} until no later than #{eote}"
      end

      # Handle special "on" case
      if (botb.known? && eotb.known? && bote.known? && eote.known?) && 
         (botb == eotb && bote == eote && botb == eote) &&
         botb.earliest == botb.latest
         return "on #{botb}"
      end

      first_string = ""
      if botb.known? && eotb.known?
        if botb == eotb
          first_string = botb
        else
          first_string = "sometime between #{botb} and #{eotb}"
        end
      elsif botb.known?
        first_string = "after #{botb}"
      elsif eotb.known?
        first_string = "by #{eotb}"
      end

      second_string = nil
      if bote.known? && eote.known?
        if bote == eote
          second_string = bote
        else
          second_string = "sometime between #{bote} and #{eote}"
        end
      elsif bote.known?
        second_string = "at least #{bote}"
      elsif eote.known?
        second_string = "no later than #{eote}"
      end

      [first_string,second_string].compact.join(" until ").strip

    end
  end
end

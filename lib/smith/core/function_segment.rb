module Smith
  module Core
    class FunctionSegment
      attr_accessor :domain
      attr_accessor :range
      attr_accessor :proc
      attr_accessor :inv
    
      def initialize( proc = nil, inverse = nil, domain = nil, range = nil )
        if domain
          unless domain.last == Smith::INF
            @domain = Range.new( domain.first, domain.last, true )
          else
            @domain = Range.new( domain.first, domain.last )
          end
        else
          @domain = nil
        end
        @proc   = proc
        @range  = (range ? Range.new( range.first, range.last ) : nil)
        @inv    = inverse
      end
    
      def call( x )
        unless @domain.member? x
          raise ValueOutsideDomainError, "Value #{x} is outside of #{@domain}"
        end
        @proc.call( x ).to_f
      end
    
      def inverse( y )
        unless @range.member? y
          raise ValueOutsideRangeError, "Value #{y} is outside of #{@range}"
        end
        # Return an array of unique x values within segment's domain
        result = [@inv.call( y )].flatten
        result = result.map {|v| v.to_f}
        result = result.select {|v| @domain.member? v}
      end
    end
  
    class ValueOutsideDomainError < Exception 
    end
    class ValueOutsideRangeError < Exception
    end
  end
end
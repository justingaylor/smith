module Smith
  module Fuzzy
    class FunctionSegment
      attr_accessor :range
      attr_accessor :proc
      
      def initialize( range = nil, proc = nil )
        @range = (range ? Range.new( range.first, range.last, true ) : nil)
        @proc  = proc
      end
      
      def call( x )
        raise ValueOutsideDomainError unless @range.member? x
        @proc.call( x )
      end
    end
    
    class ValueOutsideDomainError < Exception
    end
  end
end